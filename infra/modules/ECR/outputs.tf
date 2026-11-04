output "repository_urls" {
  value = {
    for name, repo in aws_ecr_repository.repositories :
    name => repo.repository_url
  }
}