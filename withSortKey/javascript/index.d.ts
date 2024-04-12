import { ModelInit, MutableModel, __modelMeta__, CompositeIdentifier, ManagedIdentifier } from "@aws-amplify/datastore";
// @ts-ignore
import { LazyLoading, LazyLoadingDisabled, AsyncCollection, AsyncItem } from "@aws-amplify/datastore";





type EagerPrimary = {
  readonly [__modelMeta__]: {
    identifier: CompositeIdentifier<Primary, ['tenantId', 'instanceId', 'recordId']>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly tenantId: string;
  readonly instanceId: string;
  readonly recordId: string;
  readonly content?: string | null;
  readonly related?: Related[] | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyPrimary = {
  readonly [__modelMeta__]: {
    identifier: CompositeIdentifier<Primary, ['tenantId', 'instanceId', 'recordId']>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly tenantId: string;
  readonly instanceId: string;
  readonly recordId: string;
  readonly content?: string | null;
  readonly related: AsyncCollection<Related>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type Primary = LazyLoading extends LazyLoadingDisabled ? EagerPrimary : LazyPrimary

export declare const Primary: (new (init: ModelInit<Primary>) => Primary) & {
  copyOf(source: Primary, mutator: (draft: MutableModel<Primary>) => MutableModel<Primary> | void): Primary;
}

type EagerRelated = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Related, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly content?: string | null;
  readonly primaryTenantId: string;
  readonly primaryInstanceId: string;
  readonly primaryRecordId: string;
  readonly primary?: Primary | null;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

type LazyRelated = {
  readonly [__modelMeta__]: {
    identifier: ManagedIdentifier<Related, 'id'>;
    readOnlyFields: 'createdAt' | 'updatedAt';
  };
  readonly id: string;
  readonly content?: string | null;
  readonly primaryTenantId: string;
  readonly primaryInstanceId: string;
  readonly primaryRecordId: string;
  readonly primary: AsyncItem<Primary | undefined>;
  readonly createdAt?: string | null;
  readonly updatedAt?: string | null;
}

export declare type Related = LazyLoading extends LazyLoadingDisabled ? EagerRelated : LazyRelated

export declare const Related: (new (init: ModelInit<Related>) => Related) & {
  copyOf(source: Related, mutator: (draft: MutableModel<Related>) => MutableModel<Related> | void): Related;
}