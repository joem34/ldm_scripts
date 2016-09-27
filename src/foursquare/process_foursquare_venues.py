import json
import unicodecsv as csv

venues = {}
files = ['20160914-121208', '20160917-104649']
for date in files:
    with open("output/venues_%s.json" % date) as f:
        venues.update(json.load(f))

print len(venues)
count_50 = 0
with open("output/zone_venue_stats.csv", 'w') as out:
    csvwriter = csv.writer(out)
    csvwriter.writerow(["zone_id", "venue_count", "checkin_count"])
    for (zone, vs) in venues.iteritems():
        if len(vs['venues']) == 50:
            count_50 += 1
        print (zone, len(vs['venues']))
        csvwriter.writerow([zone, len(vs['venues']), sum([v['stats']['checkinsCount'] for v in vs['venues']])])

#location.(country, state, lat, lng)
#stats.(checkinsCount, usersCount, tipCount)
#id
#categories[0..n-1](name, id)  #only take primary category

venue_id_set = set()

with open("output/all_venues.csv", 'w') as out:
    csvwriter = csv.writer(out, encoding='utf-8')
    csvwriter.writerow(["venue_id", "name", "country", "state",
                        "lon", "lat", "category_name", "category_id", "tips", "users", "checkins"])
    for vs in venues.itervalues():
        for v in vs['venues']:
            try:
                venue_id = v['id']
                venue_name = v['name']

                if venue_id in venue_id_set:
                    print "venue %s already included: %s" % (venue_id, venue_name)
                else:
                    venue_id_set.add(venue_id)

                    if 'country' in v['location']:
                        country = v['location']['country']
                    else:
                        country = ''

                    if 'state' in v['location']:
                        state = v['location']['state']
                    else:
                        state = ''

                    lon = v['location']['lng']
                    lat = v['location']['lat']

                    if len(v['categories']) > 0:
                        category_name = v['categories'][0]['name']
                        category_id = v['categories'][0]['id']
                    else:
                        category_name = ''
                        category_id = ''

                    tips = v['stats']['tipCount']
                    users = v['stats']['usersCount']
                    checkins = v['stats']['checkinsCount']
                    csvwriter.writerow([venue_id, venue_name, country, state, lon, lat, category_name,
                                       category_id, tips, users, checkins])
            except KeyError:
                print v
                exit()


print count_50