package com.amplifyframework.datastore.generated.model;

import com.amplifyframework.core.model.annotations.HasMany;
import com.amplifyframework.core.model.annotations.HasOne;
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

/** This is an auto generated class representing the Primary type in your schema. */
@SuppressWarnings("all")
@ModelConfig(pluralName = "Primaries", type = Model.Type.USER, version = 1)
@Index(name = "undefined", fields = {"id"})
public final class Primary implements Model {
  public static final QueryField ID = field("Primary", "id");
  private final @ModelField(targetType="ID", isRequired = true) String id;
  private final @ModelField(targetType="RelatedMany") @HasMany(associatedWith = "primaryId", type = RelatedMany.class) List<RelatedMany> relatedMany = null;
  private final @ModelField(targetType="RelatedOne") @HasOne(associatedWith = "primaryId", type = RelatedOne.class) RelatedOne relatedOne = null;
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
  
  public List<RelatedMany> getRelatedMany() {
      return relatedMany;
  }
  
  public RelatedOne getRelatedOne() {
      return relatedOne;
  }
  
  public Temporal.DateTime getCreatedAt() {
      return createdAt;
  }
  
  public Temporal.DateTime getUpdatedAt() {
      return updatedAt;
  }
  
  private Primary(String id) {
    this.id = id;
  }
  
  @Override
   public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      } else if(obj == null || getClass() != obj.getClass()) {
        return false;
      } else {
      Primary primary = (Primary) obj;
      return ObjectsCompat.equals(getId(), primary.getId()) &&
              ObjectsCompat.equals(getCreatedAt(), primary.getCreatedAt()) &&
              ObjectsCompat.equals(getUpdatedAt(), primary.getUpdatedAt());
      }
  }
  
  @Override
   public int hashCode() {
    return new StringBuilder()
      .append(getId())
      .append(getCreatedAt())
      .append(getUpdatedAt())
      .toString()
      .hashCode();
  }
  
  @Override
   public String toString() {
    return new StringBuilder()
      .append("Primary {")
      .append("id=" + String.valueOf(getId()) + ", ")
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
  public static Primary justId(String id) {
    return new Primary(
      id
    );
  }
  
  public CopyOfBuilder copyOfBuilder() {
    return new CopyOfBuilder(id);
  }
  public interface BuildStep {
    Primary build();
    BuildStep id(String id);
  }
  

  public static class Builder implements BuildStep {
    private String id;
    public Builder() {
      
    }
    
    private Builder(String id) {
      this.id = id;
    }
    
    @Override
     public Primary build() {
        String id = this.id != null ? this.id : UUID.randomUUID().toString();
        
        return new Primary(
          id);
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
    private CopyOfBuilder(String id) {
      super(id);
      
    }
  }
  

  public static class PrimaryIdentifier extends ModelIdentifier<Primary> {
    private static final long serialVersionUID = 1L;
    public PrimaryIdentifier(String id) {
      super(id);
    }
  }
  
}
