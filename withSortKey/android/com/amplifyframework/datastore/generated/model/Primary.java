package com.amplifyframework.datastore.generated.model;

import com.amplifyframework.core.model.annotations.HasMany;
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
@Index(name = "undefined", fields = {"tenantId","instanceId","recordId"})
public final class Primary implements Model {
  public static final QueryField TENANT_ID = field("Primary", "tenantId");
  public static final QueryField INSTANCE_ID = field("Primary", "instanceId");
  public static final QueryField RECORD_ID = field("Primary", "recordId");
  public static final QueryField CONTENT = field("Primary", "content");
  private final @ModelField(targetType="ID", isRequired = true) String tenantId;
  private final @ModelField(targetType="ID", isRequired = true) String instanceId;
  private final @ModelField(targetType="ID", isRequired = true) String recordId;
  private final @ModelField(targetType="String") String content;
  private final @ModelField(targetType="Related") @HasMany(associatedWith = "primaryTenantId", type = Related.class) List<Related> related = null;
  private @ModelField(targetType="AWSDateTime", isReadOnly = true) Temporal.DateTime createdAt;
  private @ModelField(targetType="AWSDateTime", isReadOnly = true) Temporal.DateTime updatedAt;
  private PrimaryIdentifier primaryIdentifier;
  /** @deprecated This API is internal to Amplify and should not be used. */
  @Deprecated
   public PrimaryIdentifier resolveIdentifier() {
    if (primaryIdentifier == null) {
      this.primaryIdentifier = new PrimaryIdentifier(tenantId, instanceId, recordId);
    }
    return primaryIdentifier;
  }
  
  public String getTenantId() {
      return tenantId;
  }
  
  public String getInstanceId() {
      return instanceId;
  }
  
  public String getRecordId() {
      return recordId;
  }
  
  public String getContent() {
      return content;
  }
  
  public List<Related> getRelated() {
      return related;
  }
  
  public Temporal.DateTime getCreatedAt() {
      return createdAt;
  }
  
  public Temporal.DateTime getUpdatedAt() {
      return updatedAt;
  }
  
  private Primary(String tenantId, String instanceId, String recordId, String content) {
    this.tenantId = tenantId;
    this.instanceId = instanceId;
    this.recordId = recordId;
    this.content = content;
  }
  
  @Override
   public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      } else if(obj == null || getClass() != obj.getClass()) {
        return false;
      } else {
      Primary primary = (Primary) obj;
      return ObjectsCompat.equals(getTenantId(), primary.getTenantId()) &&
              ObjectsCompat.equals(getInstanceId(), primary.getInstanceId()) &&
              ObjectsCompat.equals(getRecordId(), primary.getRecordId()) &&
              ObjectsCompat.equals(getContent(), primary.getContent()) &&
              ObjectsCompat.equals(getCreatedAt(), primary.getCreatedAt()) &&
              ObjectsCompat.equals(getUpdatedAt(), primary.getUpdatedAt());
      }
  }
  
  @Override
   public int hashCode() {
    return new StringBuilder()
      .append(getTenantId())
      .append(getInstanceId())
      .append(getRecordId())
      .append(getContent())
      .append(getCreatedAt())
      .append(getUpdatedAt())
      .toString()
      .hashCode();
  }
  
  @Override
   public String toString() {
    return new StringBuilder()
      .append("Primary {")
      .append("tenantId=" + String.valueOf(getTenantId()) + ", ")
      .append("instanceId=" + String.valueOf(getInstanceId()) + ", ")
      .append("recordId=" + String.valueOf(getRecordId()) + ", ")
      .append("content=" + String.valueOf(getContent()) + ", ")
      .append("createdAt=" + String.valueOf(getCreatedAt()) + ", ")
      .append("updatedAt=" + String.valueOf(getUpdatedAt()))
      .append("}")
      .toString();
  }
  
  public static TenantIdStep builder() {
      return new Builder();
  }
  
  public CopyOfBuilder copyOfBuilder() {
    return new CopyOfBuilder(tenantId,
      instanceId,
      recordId,
      content);
  }
  public interface TenantIdStep {
    InstanceIdStep tenantId(String tenantId);
  }
  

  public interface InstanceIdStep {
    RecordIdStep instanceId(String instanceId);
  }
  

  public interface RecordIdStep {
    BuildStep recordId(String recordId);
  }
  

  public interface BuildStep {
    Primary build();
    BuildStep content(String content);
  }
  

  public static class Builder implements TenantIdStep, InstanceIdStep, RecordIdStep, BuildStep {
    private String tenantId;
    private String instanceId;
    private String recordId;
    private String content;
    public Builder() {
      
    }
    
    private Builder(String tenantId, String instanceId, String recordId, String content) {
      this.tenantId = tenantId;
      this.instanceId = instanceId;
      this.recordId = recordId;
      this.content = content;
    }
    
    @Override
     public Primary build() {
        
        return new Primary(
          tenantId,
          instanceId,
          recordId,
          content);
    }
    
    @Override
     public InstanceIdStep tenantId(String tenantId) {
        Objects.requireNonNull(tenantId);
        this.tenantId = tenantId;
        return this;
    }
    
    @Override
     public RecordIdStep instanceId(String instanceId) {
        Objects.requireNonNull(instanceId);
        this.instanceId = instanceId;
        return this;
    }
    
    @Override
     public BuildStep recordId(String recordId) {
        Objects.requireNonNull(recordId);
        this.recordId = recordId;
        return this;
    }
    
    @Override
     public BuildStep content(String content) {
        this.content = content;
        return this;
    }
  }
  

  public final class CopyOfBuilder extends Builder {
    private CopyOfBuilder(String tenantId, String instanceId, String recordId, String content) {
      super(tenantId, instanceId, recordId, content);
      Objects.requireNonNull(tenantId);
      Objects.requireNonNull(instanceId);
      Objects.requireNonNull(recordId);
    }
    
    @Override
     public CopyOfBuilder tenantId(String tenantId) {
      return (CopyOfBuilder) super.tenantId(tenantId);
    }
    
    @Override
     public CopyOfBuilder instanceId(String instanceId) {
      return (CopyOfBuilder) super.instanceId(instanceId);
    }
    
    @Override
     public CopyOfBuilder recordId(String recordId) {
      return (CopyOfBuilder) super.recordId(recordId);
    }
    
    @Override
     public CopyOfBuilder content(String content) {
      return (CopyOfBuilder) super.content(content);
    }
  }
  

  public static class PrimaryIdentifier extends ModelIdentifier<Primary> {
    private static final long serialVersionUID = 1L;
    public PrimaryIdentifier(String tenantId, String instanceId, String recordId) {
      super(tenantId, instanceId, recordId);
    }
  }
  
}
