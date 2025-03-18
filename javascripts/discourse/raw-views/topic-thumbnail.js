import EmberObject from "@ember/object";
import discourseComputed from "discourse/lib/decorators";

export default class TopicThumbnail extends EmberObject {
  responsiveRatios = [1, 1.5, 2];

  @discourseComputed("topic.thumbnails")
  hasThumbnail(thumbnails) {
    return !!thumbnails;
  }

  @discourseComputed("topic.thumbnails", "displayWidth")
  srcSet(thumbnails, displayWidth) {
    const srcSetArray = [];

    this.responsiveRatios.forEach((ratio) => {
      const target = ratio * displayWidth;
      const match = thumbnails.find((t) => t.url && t.max_width === target);
      if (match) {
        srcSetArray.push(`${match.url} ${ratio}x`);
      }
    });

    if (srcSetArray.length === 0) {
      srcSetArray.push(`${this.original.url} 1x`);
    }

    return srcSetArray.join(",");
  }

  @discourseComputed("topic.thumbnails")
  original(thumbnails) {
    return thumbnails[0];
  }

  @discourseComputed("original")
  width(original) {
    return original.width;
  }

  @discourseComputed("original")
  isLandscape(original) {
    return original.width >= original.height;
  }

  @discourseComputed("original")
  height(original) {
    return original.height;
  }

  @discourseComputed("topic.thumbnails")
  fallbackSrc(thumbnails) {
    const largeEnough = thumbnails.filter((t) => {
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

  @discourseComputed("topic")
  url(topic) {
    return topic.linked_post_number
      ? topic.urlForPostNumber(topic.linked_post_number)
      : topic.get("lastUnreadUrl");
  }
}
