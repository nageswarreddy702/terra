provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}
variable "cluster-name" {
    default = "EKScluster"
}
variable "cluster-version" {
    default = "1.21"
}
variable "subnet-ids" {
    default = ["subnet-05eaf2c678865534d", "subnet-07ab410c26fafea5f", "subnet-029f3e0c52014ab08"]
}
variable "cluster-tags" {
    default = "eks_cluster"
}
variable "eks-node-name" {
    default = "eks-node-group"
}
variable "max-size" {
    default = "3"
}
variable "desired-size " {
    default = "1"
}    
variable "min-size" {
    default = "2"
}    
variable "volume-size" {
    default = "5"
}  
variable "volume-type" {
    default = "gp2"
}  
variable "image-id" {
    default = "ami-01e36b7901e884a10"
} 
variable "instance-type" {
    default = "t2.nano"
}   
variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}
variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
variable "key_name" {
  default = "ram"
}  