package dev.appkr.timestampDemo;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneId;

@RestController
public class PostController {

  private PostRepository repository;

  public PostController(PostRepository repository) {
    this.repository = repository;
  }

  @PostMapping(path = "/api/posts")
  @Transactional
  public ResponseEntity<PostDto> createPost(@RequestBody PostDto req) {
    Post entity = toEntity(req);
    Post saved = repository.save(entity);
    PostDto res = toDto(saved);

    return ResponseEntity.ok(res);
  }

  private Post toEntity(PostDto dto) {
    Instant now = Instant.now();
    Post entity = new Post();
    entity.setBody(dto.getBody());
    entity.setCreatedAt(now);
    entity.setUpdatedAt(now);

    return entity;
  }

  private PostDto toDto(Post entity) {
    PostDto dto = new PostDto();
    dto.setId(entity.getId());
    dto.setBody(entity.getBody());
    dto.setCreatedAt(OffsetDateTime.ofInstant(entity.getCreatedAt(), ZoneId.systemDefault()));
    dto.setUpdatedAt(OffsetDateTime.ofInstant(entity.getUpdatedAt(), ZoneId.systemDefault()));

    return dto;
  }
}
