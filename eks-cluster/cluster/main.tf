resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster-name     #"EKScluster"
  version  =  var.cluster-version  #"1.21"
  role_arn = aws_iam_role.role_cluster.arn
  depends_on = [
    aws_iam_role_policy_attachment.role_cluster_policy,
    aws_iam_role_policy_attachment.EKSServicePolicy,
   ]
  vpc_config {             # Configure EKS with vpc and network settings 
   security_group_ids = ["${aws_security_group.eks-cluster.id}"]
   subnet_ids         = var.subnet-ids   #["subnet-05eaf2c678865534d", "subnet-07ab410c26fafea5f", "subnet-029f3e0c52014ab08"] 
    }
  
  tags = {
    Name = var.cluster-tags #"eks_cluster"
  }
}

resource "aws_iam_role" "role_cluster" {
  name = "role_cluster"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
   }
  ]
 }
POLICY
}
resource "aws_iam_role_policy_attachment" "role_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "aws_iam_role.role_cluster.name"
}
resource "aws_iam_role_policy_attachment" "EKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role_cluster.name
}

resource "aws_vpc" "dev-vpc" {

  cidr_block = var.cidr_block
  tags = {
    Name = "dev-vpc"
  }
}


resource "aws_subnet" "public-subnet" {

  vpc_id = aws_vpc.dev-vpc.id
  depends_on = [
    aws_vpc.dev-vpc,
  ]
  cidr_block              = var.public_subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_security_group" "eks-cluster" {
  name        = "SG-eks-cluster"
  vpc_id      = "aws_vpc.dev-vpc.id"  

# Egress allows Outbound traffic from the EKS cluster to the  Internet 

  egress {                   # Outbound Rule
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Ingress allows Inbound traffic to EKS cluster from the  Internet 

  ingress {                  # Inbound Rule
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

