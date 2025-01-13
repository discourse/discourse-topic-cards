import Component from "@glimmer/component";
import { computed } from "@ember/object";

export default class TopicThumbnail extends Component {
  responsiveRatios = [1, 1.5, 2];

  get topic() {
    return this.args.topic || this.args.outletArgs.topic;
  }

  @computed("topic.thumbnails")
  get hasThumbnail() {
    return !!this.topic.thumbnails;
  }

  @computed("topic.thumbnails", "displayWidth")
  get srcSet() {
    const srcSetArray = [];

    this.responsiveRatios.forEach((ratio) => {
      const target = ratio * this.displayWidth;
      const match = this.topic.thumbnails.find(
        (t) => t.url && t.max_width === target
      );
      if (match) {
        srcSetArray.push(`${match.url} ${ratio}x`);
      }
    });

    if (srcSetArray.length === 0) {
      srcSetArray.push(`${this.original.url} 1x`);
    }

    return srcSetArray.join(",");
  }

  @computed("topic.thumbnails")
  get original() {
    return this.topic.thumbnails[0];
  }

  get width() {
    return this.original.width;
  }

  get isLandscape() {
    return this.original.width >= this.original.height;
  }

  get height() {
    return this.original.height;
  }

  @computed("topic.thumbnails")
  get fallbackSrc() {
    const largeEnough = this.topic.thumbnails.filter((t) => {
      if (!t.url) {
        return false;
      }
      return t.max_width > this.displayWidth * this.responsiveRatios.lastObject;
    });

    if (largeEnough.lastObject) {
      return largeEnough.lastObject.url;
    }

    return this.original.url;
  }

  get url() {
    return this.topic.linked_post_number
      ? this.topic.urlForPostNumber(this.topic.linked_post_number)
      : this.topic.get("lastUnreadUrl");
  }

  <template>
    <td class={{if this.hasThumbnail "topic-card__thumbnail" "no-thumbnail"}}>
      <a href={{this.url}}>
        {{#if this.hasThumbnail}}
          <img
            class="main-thumbnail"
            src={{this.fallbackSrc}}
            srcset={{this.srcSet}}
            width={{this.width}}
            height={{this.height}}
            loading="lazy"
          />
        {{/if}}
      </a>
    </td>
  </template>
}
