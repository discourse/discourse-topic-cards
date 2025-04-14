import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import TopicExcerpt from "../components/topic-excerpt";
import TopicMetadata from "../components/topic-metadata";
import TopicOp from "../components/topic-op";
import TopicTagsMobile from "../components/topic-tags-mobile";
import TopicThumbnail from "../components/topic-thumbnail";

export default apiInitializer("1.39.0", (api) => {
  const site = api.container.lookup("service:site");

  api.renderInOutlet(
    "topic-list-main-link-bottom",
    class extends Component {
      static shouldRender(args, context) {
        return context.siteSettings.glimmer_topic_list_mode !== "disabled";
      }

      <template>
        <TopicOp @topic={{@outletArgs.topic}} />
        <TopicExcerpt @topic={{@outletArgs.topic}} />
        <TopicMetadata @topic={{@outletArgs.topic}} />
      </template>
    }
  );

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

  api.registerValueTransformer("topic-list-item-mobile-layout", () => false);
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    columns.add("thumbnail", { item: TopicThumbnail }, { before: "topic" });

    if (site.mobileView) {
      columns.add(
        "tags-mobile",
        { item: TopicTagsMobile },
        { before: "thumbnail" }
      );
    }

    return columns;
  });

  api.registerBehaviorTransformer(
    "topic-list-item-click",
    ({ context, next }) => {
      const targetElement = context.event.target;
      const topic = context.topic;

      const clickTargets = [
        "topic-list-data",
        "link-bottom-line",
        "topic-list-item",
        "topic-card__excerpt",
        "topic-card__excerpt-text",
        "topic-card__metadata",
        "topic-card__likes",
        "topic-card__op",
      ];

      if (site.mobileView) {
        clickTargets.push("topic-item-metadata");
      }

      if (clickTargets.some((t) => targetElement.closest(`.${t}`))) {
        if (wantsNewWindow(event)) {
          return true;
        }
        return context.navigateToTopic(topic, topic.lastUnreadUrl);
      }

      next();
    }
  );
});
