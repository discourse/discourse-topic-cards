import Component from "@glimmer/component";
import categoryLink from "discourse/helpers/category-link";
import discourseTags from "discourse/helpers/discourse-tags";

export default class TopicTagsMobile extends Component {
  get category() {
    return this.topic.category;
  }

  get topic() {
    return this.args.topic || this.args.outletArgs.topic;
  }

  get tagsForUser() {
    return this.args.tagsForUser || this.args.outletArgs.tagsForUser;
  }

  <template>
    <div class="topic-card__tags">
      {{categoryLink this.category}}
      {{discourseTags this.topic mode="list" tagsForUser=this.tagsForUser}}
    </div>
  </template>
}
