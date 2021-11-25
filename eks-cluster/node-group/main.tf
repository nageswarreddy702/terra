resource "aws_iam_role" "eks_nodes" {
  name = var.eks-node-name #"eks-node-group"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attaching the different Policies to Node Members.

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Create EKS cluster node group

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "node_group1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = ["subnet-05eaf2c678865534d", "subnet-07ab410c26fafea5f", "subnet-029f3e0c52014ab08"]
  scaling_config {
    desired_size = var.desired-size # 1
    max_size     = var.max-size #1
    min_size     = var.min-size # 1
  }
  launch_template {
  name = aws_launch_template.your_eks_launch_template.name
  version = aws_launch_template.your_eks_launch_template.latest_version
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_launch_template" "your_eks_launch_template" {
  name = "your_eks_launch_template"
   description            = "Default Launch-Template"
  update_default_version = true
  
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume-size  #5
      volume_type = var.volume-type  #"gp2"
    }
  }

  image_id = var.image-id #"ami-01e36b7901e884a10"
  instance_type = var.instance-type #"t2.nano"
  security_groups        = ["${aws_security_group.instance.id}"]
  key_name               = "${var.key_name}"
}