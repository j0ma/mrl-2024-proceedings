grab_info_yaml () {
    local paper_id=$1
    yq ".[] | select(.id == ${paper_id}) | {\"id\": .id, \"title\": .title, \"emails\": [.authors[].emails], \"author_names\": [.authors[].name]}" ../../papers.yml
}

create_email_body () {
    local info_yaml=$1

    sleep 0.5

    local paper_id=$(yq '.id' < $info_yaml)
    local title=$(yq '.title' < $info_yaml)
    local emails=$(yq '.emails[]' < $info_yaml)
    local author_names=$(yq '.author_names[]' < $info_yaml | tr '\n' ', ' | sed 's/, $//g')


    cat <<EOF
Subject: [URGENT] [MRL 2024] Missing camera-ready for Submission ${paper_id}: ${title}
To: ${emails}

Dear authors,

I hope this email finds you well. I am reaching out to you regarding your submission to our workshop titled "${title}" (Submission ID: ${paper_id}).

We are currently preparing the workshop proceedings and noticed that unfortunately your latest OpenReview submission does not conform to the camera-ready guidelines. (Please find the specific errors attached below.) Could you send us the camera-ready version of your paper as soon as possible? Since the OpenReview submission window is now closed, please send your camera-ready directly to me via email at jonnesaleva@brandeis.edu. Please also CC mrlworkshop2024@gmail.com.

We highly recommend using the ACLPUBCHECK tool to check your camera-ready version before submission. You can find the tool here: https://github.com/acl-org/aclpubcheck.

Thank you for your attention to this matter, and we look forward to receiving your camera-ready submission soon.

Finally, in case you believe this message is in error, please reach out with information about your camera-ready submission.

Best regards,

Jonne Sälevä, Abraham Owodunni
Publications Chairs, MRL 2024

DETAILED ERRORS:

$(yq < ${paper_id}/errors-${paper_id}.yml)

EOF

    #rm $tempfile

}

tempfile=$(mktemp --suffix=.yml)
grab_info_yaml $1 > $tempfile
create_email_body $tempfile
#rm $tempfile
