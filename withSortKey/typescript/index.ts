import { ModelInit, MutableModel, PersistentModelConstructor } from "@aws-amplify/datastore";
import { initSchema } from "@aws-amplify/datastore";

import { schema } from "./schema";



type EagerPrimaryModel = {
  readonly [__modelMeta__]: {
    identifier: CompositeIdentifier<Primary, ['tenantId', 'instanceId', 'recordId']>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly tenantId: string;
  readonly instanceId: string;
  readonly recordId: string;
  readonly content?: string | null;
  readonly related?: RelatedModel[] | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyPrimaryModel = {
  readonly [__modelMeta__]: {
    identifier: CompositeIdentifier<Primary, ['tenantId', 'instanceId', 'recordId']>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly tenantId: string;
  readonly instanceId: string;
  readonly recordId: string;
  readonly content?: string | null;
  readonly related: AsyncCollection<RelatedModel>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type PrimaryModel = LazyLoading extends LazyLoadingDisabled ? EagerPrimaryModel : LazyPrimaryModel

export declare const PrimaryModel: (new (init: ModelInit<PrimaryModel>) => PrimaryModel) & {
  copyOf(source: PrimaryModel, mutator: (draft: MutableModel<PrimaryModel>) => MutableModel<PrimaryModel> | void): PrimaryModel;
}

type EagerRelatedModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Related, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly content?: string | null;
  readonly primaryTenantId: string;
  readonly primaryInstanceId: string;
  readonly primaryRecordId: string;
  readonly primary?: PrimaryModel | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelatedModel = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Related, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly content?: string | null;
  readonly primaryTenantId: string;
  readonly primaryInstanceId: string;
  readonly primaryRecordId: string;
  readonly primary: AsyncItem<PrimaryModel | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type RelatedModel = LazyLoading extends LazyLoadingDisabled ? EagerRelatedModel : LazyRelatedModel

export declare const RelatedModel: (new (init: ModelInit<RelatedModel>) => RelatedModel) & {
  copyOf(source: RelatedModel, mutator: (draft: MutableModel<RelatedModel>) => MutableModel<RelatedModel> | void): RelatedModel;
}



const { Primary, Related } = initSchema(schema) as {
  Primary: PersistentModelConstructor<PrimaryModel>;
  Related: PersistentModelConstructor<RelatedModel>;
};

export {
  Primary,
  Related
};