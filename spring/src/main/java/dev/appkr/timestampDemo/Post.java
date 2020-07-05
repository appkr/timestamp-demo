package dev.appkr.timestampDemo;

import javax.persistence.*;
import java.io.Serializable;
import java.time.Instant;
import java.time.OffsetDateTime;

@Entity
@Table(name = "posts")
public class Post implements Serializable {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "body")
  private String body;
  @Column(name = "created_at")
  private Instant createdAt;
  @Column(name = "updated_at")
  private Instant updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }

  public Instant getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Instant createdAt) {
    this.createdAt = createdAt;
  }

  public Instant getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(Instant updatedAt) {
    this.updatedAt = updatedAt;
  }
}
