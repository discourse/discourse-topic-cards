import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";
import { not } from "truth-helpers";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import number from "discourse/helpers/number";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export default class LikeToggle extends Component {
  @service dialog;

  @tracked likeCount = this.args.topic.like_count;
  @tracked liked = this.args.topic.op_liked || false;
  @tracked loading = false;
  clickCounter = 0;

  get canLike() {
    return this.args.topic.op_can_like || false;
  }

  get firstPostId() {
    return this.args.topic.first_post_id || false;
  }

  @action
  toggleLikeDebounced() {
    if (this.loading) {
      return;
    }

    this.clickCounter++;
    this.liked = !this.liked;
    this.likeCount += this.liked ? 1 : -1;
    debounce(this, this.performToggleLike, 1000); // 1s delay
  }

  async performToggleLike() {
    if (this.clickCounter % 2 === 0) {
      this.clickCounter = 0;
      return;
    }

    this.loading = true;

    try {
      if (this.firstPostId) {
        if (!this.liked) {
          await ajax(`/post_actions/${this.firstPostId}`, {
            type: "DELETE",
            data: { post_action_type_id: 2 },
          });
        } else {
          await ajax(`/post_actions`, {
            type: "POST",
            data: { id: this.firstPostId, post_action_type_id: 2 },
          });
        }
      }
    } catch {
      // Rollback UI changes in case of an error
      this.liked = !this.liked;
      this.likeCount += this.liked ? 1 : -1;
      this.dialog.alert(
        this.liked
          ? i18n(themePrefix("like_toggle.cannot_like_topic"))
          : i18n(themePrefix("like_toggle.cannot_remove_like"))
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
      disabled={{not this.canLike}}
      title={{if
        (this.canLike)
        (i18n (themePrefix "like_toggle.like"))
        (i18n (themePrefix "like_toggle.like_disabled"))
      }}
      class={{concatClass (if this.liked "--liked") "topic__like-button"}}
    >
      {{icon (if this.liked "heart" "d-unliked")}}
      {{#if this.likeCount}}
        {{number this.likeCount}}
      {{/if}}
    </button>
  </template>
}
