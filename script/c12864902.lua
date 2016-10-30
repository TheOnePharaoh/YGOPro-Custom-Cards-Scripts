--Elemental HERO Mirage

if not c12864902.reg then
    c12864902.reg=true
    local gettype=Card.GetType
    Card.GetType=function(c)
        if c:IsHasEffect(12864902) then
            return bit.bor(gettype(c),TYPE_NORMAL)
        else
            return gettype(c)
        end
    end
    local istype=Card.IsType
    Card.IsType=function(c,ty)
        if c:IsHasEffect(12864902) then
            return bit.band(bit.bor(gettype(c),TYPE_NORMAL),ty)~=0
        else
            return istype(c,ty)
        end
    end
end
function c12864902.initial_effect(c)
	--Normal Monster
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(12864902)
    e3:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12864902.spcon)
	c:RegisterEffect(e1)
	--special summon another one from deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12864902)	
	e2:SetTarget(c12864902.sptg)
	e2:SetOperation(c12864902.spop)
	c:RegisterEffect(e2)
	--unsynchroable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--no overlay
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--fusion limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c12864902.fusionlimit)
	c:RegisterEffect(e6)
end

function c12864902.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c12864902.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c12864902.filter(c)
	return c:IsSetCard(0x3008)
end

function c12864902.spfilter(c)
	return c:IsCode(12864902)
end
function c12864902.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12864902.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12864902.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12864902.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c12864902.fusionlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x3008)
end