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

/** This is an auto generated class representing the RelatedMany type in your schema. */
@SuppressWarnings("all")
@ModelConfig(pluralName = "RelatedManies", type = Model.Type.USER, version = 1)
@Index(name = "undefined", fields = {"id"})
public final class RelatedMany implements Model {
  public static final QueryField ID = field("RelatedMany", "id");
  public static final QueryField PRIMARY = field("RelatedMany", "primaryId");
  private final @ModelField(targetType="ID", isRequired = true) String id;
  private final @ModelField(targetType="Primary") @BelongsTo(targetName = "primaryId", targetNames = {"primaryId"}, type = Primary.class) Primary primary;
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
  
  public Primary getPrimary() {
      return primary;
  }
  
  public Temporal.DateTime getCreatedAt() {
      return createdAt;
  }
  
  public Temporal.DateTime getUpdatedAt() {
      return updatedAt;
  }
  
  private RelatedMany(String id, Primary primary) {
    this.id = id;
    this.primary = primary;
  }
  
  @Override
   public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      } else if(obj == null || getClass() != obj.getClass()) {
        return false;
      } else {
      RelatedMany relatedMany = (RelatedMany) obj;
      return ObjectsCompat.equals(getId(), relatedMany.getId()) &&
              ObjectsCompat.equals(getPrimary(), relatedMany.getPrimary()) &&
              ObjectsCompat.equals(getCreatedAt(), relatedMany.getCreatedAt()) &&
              ObjectsCompat.equals(getUpdatedAt(), relatedMany.getUpdatedAt());
      }
  }
  
  @Override
   public int hashCode() {
    return new StringBuilder()
      .append(getId())
      .append(getPrimary())
      .append(getCreatedAt())
      .append(getUpdatedAt())
      .toString()
      .hashCode();
  }
  
  @Override
   public String toString() {
    return new StringBuilder()
      .append("RelatedMany {")
      .append("id=" + String.valueOf(getId()) + ", ")
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
  public static RelatedMany justId(String id) {
    return new RelatedMany(
      id,
      null
    );
  }
  
  public CopyOfBuilder copyOfBuilder() {
    return new CopyOfBuilder(id,
      primary);
  }
  public interface BuildStep {
    RelatedMany build();
    BuildStep id(String id);
    BuildStep primary(Primary primary);
  }
  

  public static class Builder implements BuildStep {
    private String id;
    private Primary primary;
    public Builder() {
      
    }
    
    private Builder(String id, Primary primary) {
      this.id = id;
      this.primary = primary;
    }
    
    @Override
     public RelatedMany build() {
        String id = this.id != null ? this.id : UUID.randomUUID().toString();
        
        return new RelatedMany(
          id,
          primary);
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
    private CopyOfBuilder(String id, Primary primary) {
      super(id, primary);
      
    }
    
    @Override
     public CopyOfBuilder primary(Primary primary) {
      return (CopyOfBuilder) super.primary(primary);
    }
  }
  

  public static class RelatedManyIdentifier extends ModelIdentifier<RelatedMany> {
    private static final long serialVersionUID = 1L;
    public RelatedManyIdentifier(String id) {
      super(id);
    }
  }
  
}
