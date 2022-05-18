import summaryViewStoreModules from '../storeModules/summaryViewStoreModules';
import { Answer } from '@veupathdb/wdk-client/lib/Utils/WdkModel'

type StoreModules = typeof summaryViewStoreModules;

export type RootState = {
  [K in keyof StoreModules]: ReturnType<StoreModules[K]['reduce']>
}

export interface BlastSummaryViewReport extends Answer {
  blastMeta: {
    blastHeader: string;
    blastMiddle: string;
    blastFooter: string;
  }
}

export interface GenomeSummaryViewReport {
  isTruncate?: boolean;
  isDetail: boolean;
  maxLength: number;
  sequences: GenomeViewSequence[];
}

export interface GenomeViewSequence {
  sourceId: string;
  regions: GenomeViewRegion[];
  features: GenomeViewFeature[];
  length: number;
  percentLength: number;
  chromosome: string;
  organism: string;
  organismAbbrev: string;
}

export interface GenomeViewRegion {
  isForward: boolean,
  percentStart: number,
  percentLength: number,
  features: GenomeViewFeature[];
}

export interface GenomeViewFeature {
  sourceId: string;
  isForward: boolean;
  sequenceId: string;
  start: number;
  end: number;
  percentStart: number;
  percentLength: number;
  context: string;
  description: string;
}