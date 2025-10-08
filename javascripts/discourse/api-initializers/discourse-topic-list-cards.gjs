import Component from "@glimmer/component";
import { apiInitializer } from "discourse/lib/api";
import { wantsNewWindow } from "discourse/lib/intercept-click";
import TopicExcerpt from "../components/topic-excerpt";
import TopicMetadata from "../components/topic-metadata";
import TopicOp from "../components/topic-op";
import TopicTagsMobile from "../components/topic-tags-mobile";
import TopicThumbnail from "../components/topic-thumbnail";

export default apiInitializer((api) => {
  const site = api.container.lookup("service:site");
  const router = api.container.lookup("service:router");

  function enableCards() {
    if (router.currentRouteName === "topic.fromParamsNear") {
      return settings.show_for_suggested_topics;
    }

    if (settings.show_on_categories?.length === 0) {
      return true; // no categories set, so enable cards by default
    }
    const currentCat = router.currentRoute?.attributes?.category?.id;
    if (currentCat === undefined) {
      return false; // not in a category
    }
    const categoryIds = settings.show_on_categories?.split("|").map(Number);
    return categoryIds.includes(currentCat);
  }

  api.renderInOutlet(
    "topic-list-main-link-bottom",
    class extends Component {
      static shouldRender(args, context) {
        return (
          context.siteSettings.glimmer_topic_list_mode !== "disabled" &&
          enableCards()
        );
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
      if (enableCards()) {
        additionalClasses.push("topic-cards-list");
      }
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
      if (enableCards()) {
        return [...additionalClasses, ...classNames];
      } else {
        return additionalClasses;
      }
    }
  );

  api.registerValueTransformer("topic-list-item-mobile-layout", ({ value }) => {
    if (enableCards()) {
      return false;
    }
    return value;
  });

  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (enableCards()) {
      columns.add("thumbnail", { item: TopicThumbnail }, { before: "topic" });

      if (site.mobileView) {
        columns.add(
          "tags-mobile",
          { item: TopicTagsMobile },
          { before: "thumbnail" }
        );
      }
    }
    return columns;
  });

  api.registerBehaviorTransformer(
    "topic-list-item-click",
    ({ context, next }) => {
      if (enableCards()) {
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
      }

      next();
    }
  );
});
