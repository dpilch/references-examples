import { ModelInit, MutableModel, PersistentModelConstructor } from "@aws-amplify/datastore";
import { initSchema } from "@aws-amplify/datastore";

import { schema } from "./schema";



type EagerPrimaryModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<Primary, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly relatedMany?: (RelatedManyModel | null)[] | null;
  readonly relatedOne?: RelatedOneModel | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyPrimaryModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<Primary, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly relatedMany: AsyncCollection<RelatedManyModel>;
  readonly relatedOne: AsyncItem<RelatedOneModel | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type PrimaryModel = LazyLoading extends LazyLoadingDisabled ? EagerPrimaryModel : LazyPrimaryModel

export declare const PrimaryModel: (new (init: ModelInit<PrimaryModel>) => PrimaryModel) & {
  copyOf(source: PrimaryModel, mutator: (draft: MutableModel<PrimaryModel>) => MutableModel<PrimaryModel> | void): PrimaryModel;
}

type EagerRelatedManyModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedMany, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary?: PrimaryModel | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelatedManyModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedMany, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary: AsyncItem<PrimaryModel | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type RelatedManyModel = LazyLoading extends LazyLoadingDisabled ? EagerRelatedManyModel : LazyRelatedManyModel

export declare const RelatedManyModel: (new (init: ModelInit<RelatedManyModel>) => RelatedManyModel) & {
  copyOf(source: RelatedManyModel, mutator: (draft: MutableModel<RelatedManyModel>) => MutableModel<RelatedManyModel> | void): RelatedManyModel;
}

type EagerRelatedOneModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedOne, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary?: PrimaryModel | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelatedOneModel = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedOne, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary: AsyncItem<PrimaryModel | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type RelatedOneModel = LazyLoading extends LazyLoadingDisabled ? EagerRelatedOneModel : LazyRelatedOneModel

export declare const RelatedOneModel: (new (init: ModelInit<RelatedOneModel>) => RelatedOneModel) & {
  copyOf(source: RelatedOneModel, mutator: (draft: MutableModel<RelatedOneModel>) => MutableModel<RelatedOneModel> | void): RelatedOneModel;
}



const { Primary, RelatedMany, RelatedOne } = initSchema(schema) as {
  Primary: PersistentModelConstructor<PrimaryModel>;
  RelatedMany: PersistentModelConstructor<RelatedManyModel>;
  RelatedOne: PersistentModelConstructor<RelatedOneModel>;
};

export {
  Primary,
  RelatedMany,
  RelatedOne
};