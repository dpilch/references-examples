package com.amplifyframework.datastore.generated.model;

import com.amplifyframework.core.model.annotations.BelongsTo;
import com.amplifyframework.core.model.temporal.Temporal;
import com.amplifyframework.core.model.ModelIdentifier;

import java.util.List;
import java.util.UUID;
import java.util.Objects;

import androidx.core.util.ObjectsCompat;

import com.amplifyframework.core.model.Model;
import com.amplifyframework.core.model.annotations.Index;
import com.amplifyframework.core.model.annotations.ModelConfig;
import com.amplifyframework.core.model.annotations.ModelField;
import com.amplifyframework.core.model.query.predicate.QueryField;

import static com.amplifyframework.core.model.query.predicate.QueryField.field;

/** This is an auto generated class representing the Related type in your schema. */
@SuppressWarnings("all")
@ModelConfig(pluralName = "Relateds", type = Model.Type.USER, version = 1)
public final class Related implements Model {
  public static final QueryField ID = field("Related", "id");
  public static final QueryField CONTENT = field("Related", "content");
  public static final QueryField PRIMARY = field("Related", "primaryTenantId");
  private final @ModelField(targetType="ID", isRequired = true) String id;
  private final @ModelField(targetType="String") String content;
  private final @ModelField(targetType="Primary") @BelongsTo(targetName = "primaryTenantId", targetNames = {"primaryTenantId", "primaryInstanceId", "primaryRecordId"}, type = Primary.class) Primary primary;
  private @ModelField(targetType="AWSDateTime", isReadOnly = true) Temporal.DateTime createdAt;
  private @ModelField(targetType="AWSDateTime", isReadOnly = true) Temporal.DateTime updatedAt;
  /** @deprecated This API is internal to Amplify and should not be used. */
  @Deprecated
   public String resolveIdentifier() {
    return id;
  }
  
  public String getId() {
      return id;
  }
  
  public String getContent() {
      return content;
  }
  
  public Primary getPrimary() {
      return primary;
  }
  
  public Temporal.DateTime getCreatedAt() {
      return createdAt;
  }
  
  public Temporal.DateTime getUpdatedAt() {
      return updatedAt;
  }
  
  private Related(String id, String content, Primary primary) {
    this.id = id;
    this.content = content;
    this.primary = primary;
  }
  
  @Override
   public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      } else if(obj == null || getClass() != obj.getClass()) {
        return false;
      } else {
      Related related = (Related) obj;
      return ObjectsCompat.equals(getId(), related.getId()) &&
              ObjectsCompat.equals(getContent(), related.getContent()) &&
              ObjectsCompat.equals(getPrimary(), related.getPrimary()) &&
              ObjectsCompat.equals(getCreatedAt(), related.getCreatedAt()) &&
              ObjectsCompat.equals(getUpdatedAt(), related.getUpdatedAt());
      }
  }
  
  @Override
   public int hashCode() {
    return new StringBuilder()
      .append(getId())
      .append(getContent())
      .append(getPrimary())
      .append(getCreatedAt())
      .append(getUpdatedAt())
      .toString()
      .hashCode();
  }
  
  @Override
   public String toString() {
    return new StringBuilder()
      .append("Related {")
      .append("id=" + String.valueOf(getId()) + ", ")
      .append("content=" + String.valueOf(getContent()) + ", ")
      .append("primary=" + String.valueOf(getPrimary()) + ", ")
      .append("createdAt=" + String.valueOf(getCreatedAt()) + ", ")
      .append("updatedAt=" + String.valueOf(getUpdatedAt()))
      .append("}")
      .toString();
  }
  
  public static BuildStep builder() {
      return new Builder();
  }
  
  /**
   * WARNING: This method should not be used to build an instance of this object for a CREATE mutation.
   * This is a convenience method to return an instance of the object with only its ID populated
   * to be used in the context of a parameter in a delete mutation or referencing a foreign key
   * in a relationship.
   * @param id the id of the existing item this instance will represent
   * @return an instance of this model with only ID populated
   */
  public static Related justId(String id) {
    return new Related(
      id,
      null,
      null
    );
  }
  
  public CopyOfBuilder copyOfBuilder() {
    return new CopyOfBuilder(id,
      content,
      primary);
  }
  public interface BuildStep {
    Related build();
    BuildStep id(String id);
    BuildStep content(String content);
    BuildStep primary(Primary primary);
  }
  

  public static class Builder implements BuildStep {
    private String id;
    private String content;
    private Primary primary;
    public Builder() {
      
    }
    
    private Builder(String id, String content, Primary primary) {
      this.id = id;
      this.content = content;
      this.primary = primary;
    }
    
    @Override
     public Related build() {
        String id = this.id != null ? this.id : UUID.randomUUID().toString();
        
        return new Related(
          id,
          content,
          primary);
    }
    
    @Override
     public BuildStep content(String content) {
        this.content = content;
        return this;
    }
    
    @Override
     public BuildStep primary(Primary primary) {
        this.primary = primary;
        return this;
    }
    
    /**
     * @param id id
     * @return Current Builder instance, for fluent method chaining
     */
    public BuildStep id(String id) {
        this.id = id;
        return this;
    }
  }
  

  public final class CopyOfBuilder extends Builder {
    private CopyOfBuilder(String id, String content, Primary primary) {
      super(id, content, primary);
      
    }
    
    @Override
     public CopyOfBuilder content(String content) {
      return (CopyOfBuilder) super.content(content);
    }
    
    @Override
     public CopyOfBuilder primary(Primary primary) {
      return (CopyOfBuilder) super.primary(primary);
    }
  }
  

  public static class RelatedIdentifier extends ModelIdentifier<Related> {
    private static final long serialVersionUID = 1L;
    public RelatedIdentifier(String id) {
      super(id);
    }
  }
  
}
