import React, { useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';
import { useLocation, useHistory } from 'react-router-dom';
import { keyBy } from 'lodash';
import { projectId } from '../../config';
import { Loading, IconAlt } from 'wdk-client/Components';

import { makeVpdbClassNameHelper, useCommunitySiteUrl } from './Utils';

import { combineClassNames } from 'ebrc-client/components/homepage/Utils';
import { useIsRefOverflowingVertically } from 'wdk-client/Hooks/Overflow';
import { useSessionBackedState } from 'wdk-client/Hooks/SessionBackedState';
import { decode, string } from 'wdk-client/Utils/Json';

import './FeaturedTools.scss';

const cx = makeVpdbClassNameHelper('FeaturedTools');
const bgDarkCx = makeVpdbClassNameHelper('BgDark');

const FEATURED_TOOL_URL_SEGMENT = projectId + '/resources_tools.json';

type FeaturedToolResponseData = FeaturedToolEntry[];

type FeaturedToolMetadata = {
  toolListOrder: string[],
  toolEntries: Record<string, FeaturedToolEntry>
};

type FeaturedToolEntry = {
  identifier: string,
  listIconKey: string,
  listTitle: string,
  descriptionTitle?: string,
  output: string
};

function useFeaturedToolMetadata(): FeaturedToolMetadata | undefined {
  const communitySiteUrl = useCommunitySiteUrl();
  const [ featuredToolResponseData, setFeaturedToolResponseData ] = useState<FeaturedToolResponseData | undefined>(undefined);
  
  useEffect(() => {
    if (communitySiteUrl != null) {
      (async () => {
        // FIXME Add basic error-handling 
        const response = await fetch(`https://${communitySiteUrl}${FEATURED_TOOL_URL_SEGMENT}`, { mode: 'cors' });

        // FIXME Validate this JSON using a Decoder
        const responseData = await response.json() as FeaturedToolResponseData;

        setFeaturedToolResponseData(responseData);
      })();
    }
  }, [ communitySiteUrl ]);

  const featuredToolMetadata = useMemo(
    () => 
      featuredToolResponseData && 
      {
        toolListOrder: featuredToolResponseData.map(({ identifier }) => identifier),
        toolEntries: keyBy(featuredToolResponseData, 'identifier')
      }, 
    [ featuredToolResponseData ]
  );

  return featuredToolMetadata;
}

const FEATURED_TOOL_KEY = 'homepage-featured-tool';

export const FeaturedTools = () => {
  const toolMetadata = useFeaturedToolMetadata();
  const { hash } = useLocation();
  const [ selectedTool, setSelectedTool ] = useSessionBackedState<string | undefined>(
    undefined,
    FEATURED_TOOL_KEY,
    JSON.stringify,
    (s: string) => decode(string, s)
  );
  const selectedToolEntry = !toolMetadata || !selectedTool || !toolMetadata.toolEntries[selectedTool]
    ? undefined
    : hash.slice(1) ? toolMetadata.toolEntries[hash.slice(1)]
    : toolMetadata.toolEntries[selectedTool];

  useEffect(() => {
    if (
      toolMetadata && 
      toolMetadata.toolListOrder.length > 0 && 
      toolMetadata.toolEntries[toolMetadata.toolListOrder[1]] &&
      (!selectedToolEntry)
    ) {
      setSelectedTool(toolMetadata.toolListOrder[1]);
    }
  }, [ toolMetadata ]);

  return (
    <div className={cx()}>
      <div className={cx('Header')}>
        <h2>Overview of Resources and Tools</h2>
      </div>
      {
        !toolMetadata 
          ? <Loading />
          : <div className={cx('List')}>          
              <FeaturedToolList
                toolMetadata={toolMetadata}
                setSelectedTool={setSelectedTool}
                selectedTool={selectedToolEntry?.identifier}
              />
              <SelectedTool
                entry={selectedToolEntry}
              />
            </div>
      }
    </div>
  );
}

type FeaturedToolListProps = {
  toolMetadata: FeaturedToolMetadata;
  selectedTool?: string;
  setSelectedTool: (nextSelectedTool: string) => void;
};

const FeaturedToolList = ({
  toolMetadata: { toolEntries, toolListOrder },
  selectedTool,
  setSelectedTool
}: FeaturedToolListProps) => {
  const itemContainerRef = useRef<HTMLDivElement>(null);
  const [ isLeftButtonEnabled, setIsLeftButtonEnabled ] = useState(true);
  const [ isRightButtonEnabled, setIsRightButtonEnabled ] = useState(true);

  const updateButtons = useCallback(() => {
    if (itemContainerRef.current) {
      const { isLeftButtonEnabled, isRightButtonEnabled } = shouldEnableButtons(itemContainerRef.current);
      setIsLeftButtonEnabled(isLeftButtonEnabled);
      setIsRightButtonEnabled(isRightButtonEnabled);
    }
  }, [ itemContainerRef.current ]);

  useLayoutEffect(() => {
    updateButtons();

    window.addEventListener('resize', updateButtons);

    const SCROLL_EVENT_OPTIONS = { capture: false, passive: true };

    if (itemContainerRef.current) {
      itemContainerRef.current.addEventListener('scroll', updateButtons, SCROLL_EVENT_OPTIONS);
      itemContainerRef.current.addEventListener('touch', updateButtons, SCROLL_EVENT_OPTIONS);
      itemContainerRef.current.addEventListener('wheel', updateButtons, SCROLL_EVENT_OPTIONS);
    }

    return () => {
      window.removeEventListener('resize', updateButtons);

      if (itemContainerRef.current) {
        itemContainerRef.current.removeEventListener('scroll', updateButtons, SCROLL_EVENT_OPTIONS);
        itemContainerRef.current.removeEventListener('touch', updateButtons, SCROLL_EVENT_OPTIONS);
        itemContainerRef.current.removeEventListener('wheel', updateButtons, SCROLL_EVENT_OPTIONS);
      }
    };
  }, [ itemContainerRef.current, updateButtons ]);

  const onClickLeft = useCallback(() => {
    if (itemContainerRef.current) {
      const itemContainerDiv = itemContainerRef.current;
      const itemElements = [...itemContainerDiv.children] as HTMLElement[];

      const i = findNearestItemIndex(itemElements, itemContainerDiv.scrollLeft);
      const itemOffset = 
        i <= 1 
          ? itemElements[0].offsetLeft
          : itemElements[i - 2].offsetLeft + (itemElements[i - 2].clientWidth / 2)

      itemContainerDiv.scrollTo({
        top: 0,
        left: itemOffset,
        behavior: 'auto'
      });
    }
  }, [ itemContainerRef.current ]);

  const onClickRight = useCallback(() => {
    if (itemContainerRef.current) {
      const itemContainerDiv = itemContainerRef.current;
      const itemElements = [...itemContainerDiv.children] as HTMLElement[];

      const i = findNearestItemIndex(itemElements, itemContainerDiv.scrollLeft + itemContainerDiv.clientWidth);
      const itemOffset = 
        i === itemElements.length - 1
          ? itemElements[i].offsetLeft + itemElements[i].clientWidth
          : itemElements[i].offsetLeft + (itemElements[i].clientWidth / 2);
      
      itemContainerDiv.scrollTo({
        top: 0,
        left: itemOffset - itemContainerDiv.clientWidth,
        behavior: 'auto'
      });
    }
  }, [ itemContainerRef.current ]);

  return (
    <div>
      <button type="button" onClick={onClickLeft} disabled={!isLeftButtonEnabled}>
        <IconAlt fa="chevron-left fa-lg" />
      </button>
      <button type="button" onClick={onClickRight} disabled={!isRightButtonEnabled}>
        <IconAlt fa="chevron-right fa-lg" />
      </button>
      <div ref={itemContainerRef} className={cx('ListItems')}>
        {toolListOrder
          .filter(toolKey => toolEntries[toolKey])
          .map(toolKey => (
            <ToolListItem
              key={toolKey}
              entry={toolEntries[toolKey]}
              isSelected={toolKey === selectedTool}
              onSelect={() => {
                setSelectedTool(toolKey);
              }}
            />
          ))}
      </div>
    </div>
  );
};

function shouldEnableButtons(itemContainerDiv: HTMLDivElement) {
  return {
    isLeftButtonEnabled: itemContainerDiv.scrollLeft > 0,
    isRightButtonEnabled: itemContainerDiv.scrollLeft + itemContainerDiv.clientWidth < itemContainerDiv.scrollWidth
  };
}

function findNearestItemIndex(itemElements: HTMLElement[], position: number) {
  const findResult = itemElements.findIndex(itemElement => position <= itemElement.offsetLeft);

  return (findResult + itemElements.length) % itemElements.length;
}

type ToolListItemProps = {
  entry: FeaturedToolEntry;
  isSelected: boolean;
  onSelect: () => void;
};

const ToolListItem = ({ entry, onSelect, isSelected }: ToolListItemProps) => {
  const history = useHistory();
  return (
    <a
      className={cx('ListItem', isSelected && 'selected')}
      href={`#${entry.identifier}`}
      onClick={e => {
        if (e.shiftKey || e.ctrlKey) return;
        e.preventDefault();
        onSelect(); 
        history.replace(`#${entry.identifier}`);
      }}
      type="button"
    >
      <div className={cx('ListItemIconContainer')}>
        <IconAlt fa={entry.listIconKey} />
      </div>
      <span className={cx('ListItemCaption')}>
        {entry.listTitle}
      </span>
    </a>
  );
};

type SelectedToolProps = {
  entry?: FeaturedToolEntry
};

const SelectedTool = ({ entry }: SelectedToolProps) => 
  <div className={cx('Selection')}>
    {
      entry && entry.descriptionTitle &&
      <h3 className={combineClassNames(cx('SelectionHeader'), bgDarkCx())}>
        {entry.descriptionTitle}
      </h3>
    }
    <SelectionBody key={entry?.identifier} entry={entry} />
  </div>;

type SelectionBodyProps = SelectedToolProps;

const SelectionBody = ({ entry }: SelectionBodyProps) => {
  const ref = useRef<HTMLDivElement>(null);
  const isOverflowing = useIsRefOverflowingVertically(ref);
  const [ isExpanded, setExpanded ] = useState(false);

  const toggleExpanded = useCallback(() => {
    setExpanded(!isExpanded);
  }, [ isExpanded ]);

  return (
    <div className={cx('SelectionBody')}>
      {
        isOverflowing && isExpanded && <ReadMoreButton isExpanded={isExpanded} toggleExpanded={toggleExpanded} classNameModifier="top" />
      }
      <div
        ref={ref}
        className={cx('SelectionBodyContent', isExpanded && 'expanded')}
        dangerouslySetInnerHTML={{
          __html: entry?.output || '...'
        }}
      >
      </div>
      {
        isOverflowing && <ReadMoreButton isExpanded={isExpanded} toggleExpanded={toggleExpanded} />
      }
    </div>
  );
};

type ReadMoreButtonProps = {
  classNameModifier?: string,
  isExpanded: boolean,
  toggleExpanded: () => void
};

const ReadMoreButton = ({
  classNameModifier,
  isExpanded,
  toggleExpanded
}: ReadMoreButtonProps) =>
  <div className={cx('SelectionBodyReadMore', isExpanded && 'expanded', classNameModifier)}>
    <button
      type="button"
      className="link"
      onClick={toggleExpanded}
    >
      {isExpanded
        ? <React.Fragment>
            <IconAlt fa="chevron-up" />
            {' '}
            Read Less
          </React.Fragment>
        : <React.Fragment>
            <IconAlt fa="chevron-down" />
            {' '}
            Read More
          </React.Fragment>
      }
    </button>
  </div>;
