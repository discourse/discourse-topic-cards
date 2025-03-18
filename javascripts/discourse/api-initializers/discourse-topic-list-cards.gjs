import Component from "@glimmer/component";
import { eq } from "truth-helpers";
import bodyClass from "discourse/helpers/body-class";
import { apiInitializer } from "discourse/lib/api";
import { withSilencedDeprecations } from "discourse/lib/deprecated";
import ClickableTopicCard from "../components/clickable-topic-card";
import TopicExcerpt from "../components/topic-excerpt";
import TopicMetadata from "../components/topic-metadata";
import TopicOp from "../components/topic-op";
import TopicTagsMobile from "../components/topic-tags-mobile";
import TopicThumbnail from "../components/topic-thumbnail";

export default apiInitializer("1.39.0", (api) => {
  const site = api.container.lookup("service:site");

  api.renderInOutlet("above-topic-list-item", ClickableTopicCard);
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

  applyLegacyCustomizations(api, classNames, site);
});

// TODO: (discourse.hbr-topic-list-overrides) remove the customizations below after the legacy topic list is removed from core
function applyLegacyCustomizations(api, classNames, site) {
  api.renderInOutlet(
    "above-site-header",
    <template>
      {{#if (eq site.useGlimmerTopicList false)}}
        {{bodyClass "hbr-topic-list__topic-cards"}}
      {{/if}}
    </template>
  );

  withSilencedDeprecations("discourse.hbr-topic-list-overrides", () => {
    api.modifyClass("component:topic-list", {
      pluginId: "discourse-topic-list-cards",
      classNames: "topic-cards-list",
    });
    api.modifyClass("component:topic-list-item", {
      pluginId: "discourse-topic-list-cards",
      classNames: classNames.join(" "),
    });
  });
}
