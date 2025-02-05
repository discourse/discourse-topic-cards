import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";
import { eq, notEq } from "truth-helpers";
import concatClass from "discourse/helpers/concat-class";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import icon from "discourse-common/helpers/d-icon";
import i18n from "discourse-common/helpers/i18n";
import I18n from "I18n";

export default class LikeToggle extends Component {
  @service currentUser;
  @service dialog;

  @tracked likeCount = this.args.topic.like_count;
  @tracked canLike = this.args.topic.op_can_like || false;
  @tracked likeToggled = this.args.topic.op_liked || false;
  @tracked loading = false;
  clickCounter = 0;

  @action
  toggleLikeDebounced() {
    event.stopPropagation();

    if (this.loading) {
      return;
    }

    this.clickCounter++;
    this.likeToggled = !this.likeToggled;
    this.likeCount += this.likeToggled ? 1 : -1;
    debounce(this, this.performToggleLike, 1000); // 1s delay
  }

  async performToggleLike() {
    if (this.clickCounter % 2 === 0) {
      this.clickCounter = 0;
      return;
    }

    this.loading = true;

    try {
      const topicPosts = await ajax(`/t/${this.args.topic.id}/post_ids.json`);

      if (topicPosts?.post_ids.length) {
        const firstPost = topicPosts.post_ids[0];

        if (firstPost) {
          if (!this.likeToggled) {
            await ajax(`/post_actions/${firstPost}`, {
              type: "DELETE",
              data: { post_action_type_id: 2 },
            });
          } else {
            await ajax(`/post_actions`, {
              type: "POST",
              data: { id: firstPost, post_action_type_id: 2 },
            });
          }
        }
      }
    } catch {
      // Rollback UI changes in case of an error
      this.likeToggled = !this.likeToggled;
      this.likeCount += this.likeToggled ? 1 : -1;
      this.dialog.alert(
        this.likeToggled
          ? I18n.t(themePrefix("like_toggle.cannot_like_topic"))
          : I18n.t(themePrefix("like_toggle.cannot_remove_like"))
      );
    } finally {
      this.loading = false;
      this.clickCounter = 0;
    }
  }

  <template>
    <button
      {{on "click" this.toggleLikeDebounced}}
      type="button"
      disabled={{eq this.canLike false}}
      title={{if
        (eq this.canLike false)
        (i18n (themePrefix "like_toggle.like_disabled"))
        (i18n (themePrefix "like_toggle.like"))
      }}
      class={{concatClass (if this.likeToggled "--liked") "topic__like-button"}}
    >
      {{#if this.likeToggled}}
        {{icon "heart"}}
      {{else}}
        {{icon "d-unliked"}}
      {{/if}}
      {{#if (notEq this.likeCount 0)}}
        {{number this.likeCount}}
      {{/if}}
    </button>
  </template>
}
