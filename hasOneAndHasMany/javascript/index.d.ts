import { ModelInit, MutableModel, __modelMeta__, OptionallyManagedIdentifier } from "@aws-amplify/datastore";
// @ts-ignore
import { LazyLoading, LazyLoadingDisabled, AsyncCollection, AsyncItem } from "@aws-amplify/datastore";





type EagerPrimary = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<Primary, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly relatedMany?: (RelatedMany | null)[] | null;
  readonly relatedOne?: RelatedOne | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyPrimary = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<Primary, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly relatedMany: AsyncCollection<RelatedMany>;
  readonly relatedOne: AsyncItem<RelatedOne | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type Primary = LazyLoading extends LazyLoadingDisabled ? EagerPrimary : LazyPrimary

export declare const Primary: (new (init: ModelInit<Primary>) => Primary) & {
  copyOf(source: Primary, mutator: (draft: MutableModel<Primary>) => MutableModel<Primary> | void): Primary;
}

type EagerRelatedMany = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedMany, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary?: Primary | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelatedMany = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedMany, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary: AsyncItem<Primary | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type RelatedMany = LazyLoading extends LazyLoadingDisabled ? EagerRelatedMany : LazyRelatedMany

export declare const RelatedMany: (new (init: ModelInit<RelatedMany>) => RelatedMany) & {
  copyOf(source: RelatedMany, mutator: (draft: MutableModel<RelatedMany>) => MutableModel<RelatedMany> | void): RelatedMany;
}

type EagerRelatedOne = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedOne, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary?: Primary | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelatedOne = {
  readonly [__modelMeta__]: {
    identifier: OptionallyManagedIdentifier<RelatedOne, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly primaryId: string;
  readonly primary: AsyncItem<Primary | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type RelatedOne = LazyLoading extends LazyLoadingDisabled ? EagerRelatedOne : LazyRelatedOne

export declare const RelatedOne: (new (init: ModelInit<RelatedOne>) => RelatedOne) & {
  copyOf(source: RelatedOne, mutator: (draft: MutableModel<RelatedOne>) => MutableModel<RelatedOne> | void): RelatedOne;
}