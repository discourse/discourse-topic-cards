import { withPluginApi } from "discourse/lib/plugin-api";
import TopicTagsMobile from "../components/topic-tags-mobile";
import TopicThumbnail from "../components/topic-thumbnail";

export default {
  name: "discourse-topic-list-cards",
  initialize() {
    withPluginApi("1.39.0", (api) => this.initWithApi(api));
  },

  initWithApi(api) {
    api.registerValueTransformer(
      "topic-list-class",
      ({ value: additionalClasses }) => {
        additionalClasses.push("topic-cards-list");
        return additionalClasses;
      }
    );

    const classNames = ["topic-card"];

    if (settings.set_card_max_height) {
      classNames.push("has-max-height");
    }

    api.registerValueTransformer(
      "topic-list-item-class",
      ({ value: additionalClasses }) => {
        return [...additionalClasses, ...classNames];
      }
    );

    api.renderBeforeWrapperOutlet("topic-list-data-mobile", TopicTagsMobile);
    api.renderBeforeWrapperOutlet("topic-list-data-mobile", TopicThumbnail);

    api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
      columns.add("thumbnail", { item: TopicThumbnail }, { before: "topic" });
      return columns;
    });
  },
};
