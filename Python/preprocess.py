# coding=utf-8
from lytools import *
import osgeo_utils.gdal_merge as gdal_merge
import fiona
T = Tools()
this_root = 'D:/AGB_project/'
data_root = 'D:/AGB_project/data/'

class NBCD:
    def __init__(self):
        self.datadir = join(data_root, 'Natl Biomass Carbon Dataset')
        pass

    def run(self):
        self.clip_CA()
        pass

    def reproj(self):
        res = 0.0024 # 240m
        fpath = join(self.datadir,r'NBCD2000_V2_1161\NBCD2000_V2_1161\data\NBCD_countrywide_biomass_240m_raster\NBCD_countrywide_biomass_mosaic.tif')
        outdir = join(self.datadir, 'reproj')
        T.mkdir(outdir, force=True)
        outf = join(outdir, 'NBCD_biomass_wgs84.tif')
        src_wkt = self.wkt_NBCD()
        dst_wkt = self.wkt_84()
        srcSRS = osr.SpatialReference()
        srcSRS.ImportFromWkt(src_wkt)

        dstSRS = osr.SpatialReference()
        dstSRS.ImportFromWkt(dst_wkt)
        dataset = gdal.Open(fpath)
        gdal.Warp(outf, dataset, xRes=res, yRes=res, srcSRS=srcSRS, dstSRS=dstSRS)

        pass

    def clip_AZ(self):
        shp_path = join(this_root,'shp','AZ_shp','az.shp')
        fpath = join(self.datadir, 'reproj', 'NBCD_biomass_wgs84.tif')
        outdir = join(self.datadir, 'clip')
        T.mkdir(outdir, force=True)
        outf = join(outdir, 'NBCD_biomass_wgs84_AZ.tif')
        ToRaster().clip_array(fpath, outf, shp_path)

        pass

    def clip_CA(self):
        shp_path = join(this_root,'shp','CA_shp','ca.shp')
        fpath = join(self.datadir, 'reproj', 'NBCD_biomass_wgs84.tif')
        outdir = join(self.datadir, 'clip')
        T.mkdir(outdir, force=True)
        outf = join(outdir, 'NBCD_biomass_wgs84_CA.tif')
        ToRaster().clip_array(fpath, outf, shp_path)

        pass

    def wkt_NBCD(self):
        wkt_str = '''PROJCRS["USA_Contiguous_Albers_Equal_Area_Conic",
    BASEGEOGCRS["NAD83",
        DATUM["North American Datum 1983",
            ELLIPSOID["GRS 1980",6378137,298.257222101,
                LENGTHUNIT["metre",1]]],
        PRIMEM["Greenwich",0,
            ANGLEUNIT["degree",0.0174532925199433]],
        ID["EPSG",4269]],
    CONVERSION["USA_Contiguous_Albers_Equal_Area_Conic",
        METHOD["Albers Equal Area",
            ID["EPSG",9822]],
        PARAMETER["Latitude of false origin",37.5,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8821]],
        PARAMETER["Longitude of false origin",-96,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8822]],
        PARAMETER["Latitude of 1st standard parallel",29.5,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8823]],
        PARAMETER["Latitude of 2nd standard parallel",45.5,
            ANGLEUNIT["degree",0.0174532925199433],
            ID["EPSG",8824]],
        PARAMETER["Easting at false origin",0,
            LENGTHUNIT["metre",1],
            ID["EPSG",8826]],
        PARAMETER["Northing at false origin",0,
            LENGTHUNIT["metre",1],
            ID["EPSG",8827]]],
    CS[Cartesian,2],
        AXIS["(E)",east,
            ORDER[1],
            LENGTHUNIT["metre",1]],
        AXIS["(N)",north,
            ORDER[2],
            LENGTHUNIT["metre",1]],
    USAGE[
        SCOPE["Not known."],
        AREA["United States (USA) - CONUS onshore - Alabama; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming."],
        BBOX[24.41,-124.79,49.38,-66.91]],
    ID["ESRI",102003]]'''
        return wkt_str

    def wkt_84(self):
        wkt_str = '''GEOGCRS["WGS 84",
    ENSEMBLE["World Geodetic System 1984 ensemble",
        MEMBER["World Geodetic System 1984 (Transit)"],
        MEMBER["World Geodetic System 1984 (G730)"],
        MEMBER["World Geodetic System 1984 (G873)"],
        MEMBER["World Geodetic System 1984 (G1150)"],
        MEMBER["World Geodetic System 1984 (G1674)"],
        MEMBER["World Geodetic System 1984 (G1762)"],
        MEMBER["World Geodetic System 1984 (G2139)"],
        ELLIPSOID["WGS 84",6378137,298.257223563,
            LENGTHUNIT["metre",1]],
        ENSEMBLEACCURACY[2.0]],
    PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433]],
    CS[ellipsoidal,2],
        AXIS["geodetic latitude (Lat)",north,
            ORDER[1],
            ANGLEUNIT["degree",0.0174532925199433]],
        AXIS["geodetic longitude (Lon)",east,
            ORDER[2],
            ANGLEUNIT["degree",0.0174532925199433]],
    USAGE[
        SCOPE["Horizontal component of 3D system."],
        AREA["World."],
        BBOX[-90,-180,90,180]],
    ID["EPSG",4326]]'''
        return wkt_str

class GFW:
    def __init__(self):
        self.datadir = join(data_root, 'GFW')
        pass

    def run(self):
        self.resample()
        self.merge_tiles()
        self.clip_AZ()
        self.clip_CA()
        pass

    def resample(self):
        res = 0.0024  # 240m
        fdir = join(self.datadir,'tiles')
        outdir = join(self.datadir,'tiles_resample')
        T.mkdir(outdir)
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            out_f = join(outdir, f)
            wkt_str = self.wkt_84()
            SRS = osr.SpatialReference()
            SRS.ImportFromWkt(wkt_str)
            dataset = gdal.Open(fpath)
            gdal.Warp(out_f, dataset, xRes=res, yRes=res, srcSRS=SRS, dstSRS=SRS)
        pass

    def merge_tiles(self):
        # fdir = join(self.datadir,'tiles_resample')
        fdir = join(self.datadir,'tiles')
        outdir = join(self.datadir,'merged')
        T.mkdir(outdir)
        outf = join(outdir,'merged.tif')
        tiles_list = []
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            tiles_list.append(fpath)
        parameters = ['', '-o', outf] + tiles_list
        gdal_merge.gdal_merge(parameters)

    def clip_AZ(self):
        shp_path = join(this_root, 'shp', 'AZ_shp', 'az.shp')
        fdir = join(self.datadir,'merged')
        outdir = join(self.datadir,'merged_clip')
        T.mkdir(outdir)
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            out_f = join(outdir, 'GFW_AZ.tif')
            ToRaster().clip_array(fpath, out_f, shp_path)
        pass

    def clip_CA(self):
        shp_path = join(this_root, 'shp', 'CA_shp', 'ca.shp')
        fdir = join(self.datadir,'merged')
        outdir = join(self.datadir,'merged_clip')
        T.mkdir(outdir)
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            out_f = join(outdir, 'GFW_CA.tif')
            ToRaster().clip_array(fpath, out_f, shp_path)
        pass

    def wkt_84(self):
        wkt_str = '''GEOGCRS["WGS 84",
    ENSEMBLE["World Geodetic System 1984 ensemble",
        MEMBER["World Geodetic System 1984 (Transit)"],
        MEMBER["World Geodetic System 1984 (G730)"],
        MEMBER["World Geodetic System 1984 (G873)"],
        MEMBER["World Geodetic System 1984 (G1150)"],
        MEMBER["World Geodetic System 1984 (G1674)"],
        MEMBER["World Geodetic System 1984 (G1762)"],
        MEMBER["World Geodetic System 1984 (G2139)"],
        ELLIPSOID["WGS 84",6378137,298.257223563,
            LENGTHUNIT["metre",1]],
        ENSEMBLEACCURACY[2.0]],
    PRIMEM["Greenwich",0,
        ANGLEUNIT["degree",0.0174532925199433]],
    CS[ellipsoidal,2],
        AXIS["geodetic latitude (Lat)",north,
            ORDER[1],
            ANGLEUNIT["degree",0.0174532925199433]],
        AXIS["geodetic longitude (Lon)",east,
            ORDER[2],
            ANGLEUNIT["degree",0.0174532925199433]],
    USAGE[
        SCOPE["Horizontal component of 3D system."],
        AREA["World."],
        BBOX[-90,-180,90,180]],
    ID["EPSG",4326]]'''
        return wkt_str

class Harmonized_Forest_Biomass_Spawn:

    def __init__(self):
        self.datadir = join(data_root, 'Harmonized Forest Biomass Spawn')
        pass

    def run(self):
        self.clip_AZ()
        self.clip_CA()
        pass

    def clip_AZ(self):
        shp_path = join(this_root, 'shp', 'AZ_shp', 'az.shp')
        fdir = join(self.datadir,'tif')
        outdir = join(self.datadir,'tif_clip')
        T.mkdir(outdir)
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            out_f = join(outdir, 'HFBS_AZ.tif')
            ToRaster().clip_array(fpath, out_f, shp_path)
        pass

    def clip_CA(self):
        shp_path = join(this_root, 'shp', 'CA_shp', 'ca.shp')
        fdir = join(self.datadir,'tif')
        outdir = join(self.datadir,'tif_clip')
        T.mkdir(outdir)
        for f in T.listdir(fdir):
            if not f.endswith('.tif'):continue
            fpath = join(fdir, f)
            out_f = join(outdir, 'HFBS_CA.tif')
            ToRaster().clip_array(fpath, out_f, shp_path)
        pass


class ICEsat:

    def __init__(self):
        self.datadir = join(data_root, 'ICESat-2 Boreal Biomass')
        res = 0.01
        self.D = DIC_and_TIF(pixelsize=res)
        pass

    def run(self):
        self.point_to_dict()
        self.dict_to_tif()
        pass

    def point_to_dict(self):
        outdir = join(self.datadir,'point_to_dict')
        T.mkdir(outdir)
        lon_col = 'lon'
        lat_col = 'lat'
        year_col = 'YEAR'
        doy_col = 'DOY'
        lc_col = 'seg_landcov'
        value_col = 'AGB_mean_mg_ha'
        fpath = join(self.datadir,'gpkg','IS2ATBABD_20190501_20210930_v01.gpkg')
        layer = fiona.open(fpath)
        # print(len(layer));exit()
        for feature in layer:
            geometry = feature['geometry']
            properties = feature['properties']
            for p in properties:
                print(p, properties[p])
            break

        value_dict_all = {}
        flag = 0
        spatial_dict = {}
        for feature in tqdm(layer):
            geometry = feature['geometry']
            properties = feature['properties']
            lon = properties[lon_col]
            lat = properties[lat_col]
            pix = self.D.lon_lat_to_pix([lon], [lat])[0]
            if not pix in spatial_dict:
                spatial_dict[pix] = []
            year = properties[year_col]
            value = properties[value_col] # AGB_mean_mg_ha
            spatial_dict[pix].append(value)
            value_dict = {
                'lon': lon,
                'lat': lat,
                'year': year,
                'value': value
            }
        # outf = join(outdir,'spatial_dict')
        T.save_distributed_perpix_dic(spatial_dict, outdir)
        # T.save_npy(spatial_dict, outf)

    def dict_to_tif(self):
        outdir = join(self.datadir,'tif')
        T.mkdir(outdir)
        fdir = join(self.datadir,'point_to_dict')
        spatial_dict = {}
        for f in tqdm(T.listdir(fdir)):
            fpath = join(fdir,f)
            spatial_dict_i = T.load_npy(fpath)
            for pix in spatial_dict_i:
                vals = spatial_dict_i[pix]
                spatial_dict[pix] = np.nanmean(vals)
        outf = join(outdir,'ICEsat_AGB.tif')
        self.D.pix_dic_to_tif(spatial_dict, outf)


def main():
    NBCD().run()
    GFW().run()
    Harmonized_Forest_Biomass_Spawn().run()
    ICEsat().run()
    pass

if __name__ == '__main__':
    main()