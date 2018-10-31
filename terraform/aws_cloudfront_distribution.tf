resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.video_stream.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.video_stream.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.video_stream.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"  # HTTP and HTTPS
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
     locations        = ["US", "CA", "GB", "DE", "JP"]
   }
 }

 viewer_certificate {
   cloudfront_default_certificate = true
 }
}
