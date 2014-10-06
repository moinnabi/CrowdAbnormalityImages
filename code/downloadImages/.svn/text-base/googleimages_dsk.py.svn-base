"""Google Image Downloader
Original written by Neeraj Kumar <me@neerajkumar.org>
DO NOT DISTRIBUTE!
"""
from PIL import Image
import os, sys, time
import urllib
import random
from Queue import Queue

# GLOBALS
# queues for managing downloads
dlq = Queue()
outq = Queue()
# number of simultaneous download threads
NDLTHREADS = 16
# the API requires you to set these variables:
REFERRER = 'http://cnet.com/'
#USERIP = '24.18.226.243' 
USERIP = '24.18.226.' + str(random.randint(100, 250))

class CustomURLopener(urllib.FancyURLopener):
    """Custom url opener that defines a new user-agent.
    Needed so that sites don't block us as a crawler."""
    version = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5"

    def prompt_user_passwd(host, realm):
        """Custom user-password func for downloading, to make sure that we don't block"""
        return ('', '')

urllib._urlopener = CustomURLopener()

def spawnWorkers(num, target, name=None, args=(), kwargs={}, daemon=1, interval=0):
    """Spawns the given number of workers, by default daemon, and returns a list of them.
    'interval' determines the time delay between each launching"""
    from threading import Thread
    threads = []
    for i in range(num):
        t = Thread(target=target, name=name, args=args, kwargs=kwargs)
        t.setDaemon(daemon)
        t.start()
        threads.append(t)
        time.sleep(interval)
    return threads

def dlthread(dlq=dlq, outq=outq):
    """An infinite loop which downloads images from dlq.
    Each item in dlq should be a (url, fname, callback).
    Downloads to fname, creating parent dirs.
    Once it's downloaded, puts (url, fname) on outq.
    On error, puts (url, None) on outq.
    If callback is not None, then calls it with (url, fname).
    """
    from urllib import urlretrieve
    while 1:
        u, f, callback = dlq.get()
        if not u: break
        try:
            os.makedirs(os.path.dirname(f))
        except OSError: pass
        try:
            fname, junk = urlretrieve(u, f)
        except Exception, e:
            print >>sys.stderr, 'Exception on %s -> %s: %s' % (u, f, e)
            fname = None
        outq.put((u,fname))
        if callback:
            callback(u, fname)

# spawn the download threads
dlthreads = spawnWorkers(NDLTHREADS, dlthread, interval=0)

class GoogleImages(object):
    """A google images searcher"""
    def __init__(self, outdir='/projects/grail/santosh/objectNgrams/results/ngramPruning/horse/images/', **dlkw):
        """Initializes with simple setup.
        Also accepts kwargs, which will be used when constructing the url.
        See https://developers.google.com/image-search/v1/jsondevguide for details.
        By default, the following args are set:
	    imgc=color|gray
            imgsz='small|medium|large|xlarge|xxlarge|huge' (notice that 'icon' is missing)
            imgtype='photo' (other options: face, clipart, lineart, None (for all)
        """
        self.outdir = outdir
        self.dlkw = dict(imgsz='small|medium|large|xlarge|xxlarge|huge', imgtype='photo',imgc='color')
        self.dlkw.update(dlkw)

    def _dl(self, q, downdir, urlstring, callback=None, limit=0, delay=0.01):
        """Main internal download function.
        Given a search term as 'q', downloads images to our outdir.
        Returns (allret, urls, fnames), where:
            allret is a list of result dicts from google images
            urls is a list of thumbnail urls
            fnames is a list of downloaded image paths
        Note that the output images are at self.outdir/q/imageid.jpg
        If you pass a callback, it's called for each individual image downloaded:
            callback(idx, result obj, path)
        where:
            'idx' is the index of the downloaded image (not necessarily in order),
            'result obj' is the object returned by the google API, and
            'path' is the path to the downloaded image
        You can optionally pass a limit >0 to limit results to that many.
        The delay is used to busy-wait-sleep at the end, waiting for all images to download
	urlstring can be 'tbUrl' or 'url'
        """
        import urllib2
        from urllib import quote_plus
        try:
            import simplejson as json
        except ImportError:
            import json
        todo = {}
        ret = []
        """dir = os.path.join(downdir, q)"""
        dir = downdir 
        def wrapped_callback(url, fname, todo=todo, ret=ret, callback=callback):
            """Wrap the user callback here.
            Also do other bookkeeping."""
            r = todo.get(url, None)
            if r and fname:
                ret.append((r, url, fname))
                if callback:
                    callback(len(ret)-1, r, fname)
            todo.pop(url, None)

        # iterate through different pages (can't get more than 8 per page)
        # google only supports upto 64 results
        #TODO see if we can simultaneously make all requests, or if that speeds things up
        t1 = time.time()
        for start in [0, 8, 16, 24, 32, 40, 48, 56]:
            # note that we exclude very small image sizes
            d = dict(userip=USERIP, q=quote_plus(q), start=start)
            url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%(q)s&userip=%(userip)s&rsz=8&start=%(start)d' % (d)
            # also add our dlkw
            url += ''.join(['&%s=%s' % (k, v) for k, v in self.dlkw.iteritems() if v])
            request = urllib2.Request(url, None, {'Referer': REFERRER})
            response = urllib2.urlopen(request)
            results = json.load(response)['responseData']['results']
            if not results: break
            for r in results:
                url = r[urlstring]
                fname = os.path.join(dir, '%s.jpg' % r['imageId'])
                todo[url] = r
                dlq.put((url, fname, wrapped_callback))
            if limit > 0 and len(ret) >= limit: break
        # wait until all todo are done
        while 1:
            if not todo: break
            if limit > 0 and len(ret) >= limit: break
            time.sleep(delay)
        if ret:
            if limit > 0:
                ret = ret[:limit]
            return zip(*ret)
        return ([], [], [])

    def getthumbs(self, term, downdir, urlstring, callback=None, limit=0):
        """Downloads all thumbnails for the given term (if needed).
        Checks for a json file in the appropriate location first.
        If you pass a callback, it's called for each individual image downloaded:
            callback(idx, result obj, path)
        where:
            'idx' is the index of the downloaded image (not necessarily in order),
            'result obj' is the object returned by the google API, and
            'path' is the path to the downloaded image
        You can optionally pass a limit >0 to limit results to that many.
        Returns a list of valid image filenames.
        """
        try:
            import simplejson as json
        except ImportError:
            import json
        """dir = os.path.join(downdir, term)"""
	dir = downdir
        jsonfname = os.path.join(dir, 'index.json')
        try:
            results = json.load(open(jsonfname))
            # we still need to call the callbacks
            if callback:
                for i, (r, im) in enumerate(zip(results['results'], results['thumbfnames'])):
                    if limit > 0 and i >= limit: break
                    callback(i, r, im)
        except Exception:
            # we don't have valid results, so re-download
            ret, urls, fnames = self._dl(term, downdir, urlstring, callback=callback, limit=limit)
            results = dict(results=ret, thumburls=urls, thumbfnames=fnames)
            try:
                os.makedirs(os.path.dirname(jsonfname))
            except OSError: pass
            json.dump(results, open(jsonfname, 'w'), indent=2)
        # at this point, we have results one way or the other
        return results['thumbfnames'][:limit] if limit > 0 else results['thumbfnames']

def testgoog():
    """Tests the google image downloader"""
    G = GoogleImages()
    start = time.time()
    downdir = sys.argv[1]
    urlstring = sys.argv[2]
    for term in sys.argv[3:]:
        done = 0
        attempt = 0
        while not done:
            attempt += 1
	    # next three lines added by dsk
            if attempt > 10:
		 print 'Too many attempts, so quitting'
		 break
            try:
                t1 = time.time()
                print 'Attempt #%d to download images for term "%s" (%0.3fs elapsed since start)' % (attempt, term, t1-start)
                def callback(idx, obj, fname):
                    """Simple callback that prints info"""
                    print '  For term "%s" got image #%d in %0.3fs: %s' % (term, idx+1, time.time()-t1, fname)

                ret = G.getthumbs(term, downdir, urlstring, callback=callback)
                print 'Downloaded %d images in %0.3f secs for query "%s"\n' % (len(ret), time.time()-t1, term)
                done = 1
            except Exception, e:
                print 'Caught exception %s, so sleeping for a bit' % (e,)
                time.sleep(10)
        time.sleep(0.1)

if __name__ == '__main__':
    testgoog()

