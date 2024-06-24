import EmberObject from "@ember/object";

import discourseComputed from "discourse-common/utils/decorators";

export default EmberObject.extend({
    @discourseComputed("topic.posts_count")
    replyCount(postsCount) {
        return postsCount - 1;
    }
});
