resource aws_s3_bucket runner_cache {
	bucket = "${local.project_prefix_alternate}-runner-cache"
	force_destroy = true
	
	tags = {
		Name = "${local.project_name} Runner Cache Bucket"
	}
}


resource aws_s3_bucket_public_access_block runner_cache {
	bucket = aws_s3_bucket.runner_cache.id
	
	block_public_acls = true
	ignore_public_acls = true
	block_public_policy = true
	restrict_public_buckets = true
}


resource aws_s3_bucket_lifecycle_configuration runner_cache {
	bucket = aws_s3_bucket.runner_cache.id
	
	rule {
		id = "Delete Old Archives"
		status = "Enabled"
		
		expiration {
			days = 30
		}
	}
}