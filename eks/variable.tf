variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "eks-demo1"
}

variable "aws_image_repository" {
  type        = string
  description = "AWS image repository for us-west-2 region" ## https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  default     = ""
}
