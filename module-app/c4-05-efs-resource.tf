# Resource: Security Group - Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System
resource "aws_security_group" "efs_allow_access" {
  name        = "efs-allow-nfs-from-eks-vpc"
  description = "Allow Inbound NFS Traffic from EKS VPC CIDR"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nfs_from_eks_vpc"
  }
}


# Resource: EFS File System Temporary Swap Resource☺☺
resource "aws_efs_file_system" "efs_keycloak_file_system" {
  creation_token = "efs-keycloak"
  tags = {
    Name = "efs-keycloak"
  }
}

# Resource: EFS Mount Target
resource "aws_efs_mount_target" "efs_keycloak_mount_target" {
  #for_each = toset(module.vpc.private_subnets)
  count = var.vpc_public_subnets_count
  file_system_id = aws_efs_file_system.efs_keycloak_file_system.id
  subnet_id      = var.vpc_public_subnets[count.index]
  security_groups = [ aws_security_group.efs_allow_access.id ]
}

# Resource: EFS File System Temporary Swap Resource☺☺
resource "aws_efs_file_system" "efs_mongodb_file_system" {
  creation_token = "efs-mongodb"
  tags = {
    Name = "efs-mongodb"
  }
}

# Resource: EFS Mount Target
resource "aws_efs_mount_target" "efs_mongodb_mount_target" {
  #for_each = toset(module.vpc.private_subnets)
  count = var.vpc_public_subnets_count
  file_system_id = aws_efs_file_system.efs_mongodb_file_system.id
  subnet_id      = var.vpc_public_subnets[count.index]
  security_groups = [ aws_security_group.efs_allow_access.id ]
}
