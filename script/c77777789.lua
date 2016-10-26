--Hellformed Aetherial Prophet Arturia
function c77777789.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c77777789.fcon)
	e1:SetOperation(c77777789.fop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c77777789.aclimit)
	e2:SetCondition(c77777789.actcon)
	c:RegisterEffect(e2)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c77777789.rmtg)
	e5:SetOperation(c77777789.rmop)
	c:RegisterEffect(e5)
	--SS
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777789,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCost(c77777789.spcon)
	e6:SetTarget(c77777789.sptg)
	e6:SetOperation(c77777789.spop)
	c:RegisterEffect(e6)
end

function c77777789.ffilter1(c)
	return c:IsSetCard(0x144) 
end
function c77777789.ffilter2(c)
	return c:IsSetCard(0x3e7)
end
function c77777789.ffilter3(c)
	return c:IsSetCard(0x407)
end
function c77777789.fcon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return (c77777789.ffilter1(gc) and mg:IsExists(c77777789.ffilter2,1,gc)and mg:IsExists(c77777789.ffilter3,1,gc)) 
			or (c77777789.ffilter2(gc) and mg:IsExists(c77777789.ffilter1,1,gc)and mg:IsExists(c77777789.ffilter3,1,gc))
			or (c77777789.ffilter3(gc) and mg:IsExists(c77777789.ffilter1,1,gc)and mg:IsExists(c77777789.ffilter2,1,gc))
	end
	local g1=mg:Filter(c77777789.ffilter1,nil)
	local g2=mg:Filter(c77777789.ffilter2,nil)
	local g3=mg:Filter(c77777789.ffilter3,nil)
	local g4=mg:Filter(c77777789.ffilter1,nil)
	g4:Merge(g2)
	g4:Merge(g3)
	return g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>2
end

function c77777789.fop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
	local sg=Group.CreateGroup()
	if c77777789.ffilter1(gc) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:FilterSelect(tp,c77777789.ffilter2,1,1,gc)
 sg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=g:FilterSelect(tp,c77777789.ffilter3,1,1,gc)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
	end
	if c77777789.ffilter2(gc) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:FilterSelect(tp,c77777789.ffilter1,1,1,gc)
 sg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=g:FilterSelect(tp,c77777789.ffilter3,1,1,gc)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
	end
	if c77777789.ffilter3(gc) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:FilterSelect(tp,c77777789.ffilter1,1,1,gc)
 sg:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=g:FilterSelect(tp,c77777789.ffilter2,1,1,gc)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
	end
	return
	end
	local sg2=g:Filter(c77777789.ffilter1,nil)
	local sg=g:Filter(c77777789.ffilter2,nil)
	local sg3=g:Filter(c77777789.ffilter3,nil)
	sg:Merge(sg2)
	sg:Merge(sg3)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
	g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else
	g1=sg:Select(tp,1,1,nil)
	end
	local tc=g1:GetFirst()
	if c77777789.ffilter1(tc) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:FilterSelect(tp,c77777789.ffilter2,1,1,tc)
 sg:RemoveCard(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:FilterSelect(tp,c77777789.ffilter3,1,1,tc)
	g1:Merge(g2)
	g1:Merge(g3)
	elseif c77777789.ffilter2(tc)then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:FilterSelect(tp,c77777789.ffilter1,1,1,tc)
 sg:RemoveCard(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:FilterSelect(tp,c77777789.ffilter3,1,1,tc)
	g1:Merge(g2)
	g1:Merge(g3)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:FilterSelect(tp,c77777789.ffilter1,1,1,tc)
 sg:RemoveCard(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:FilterSelect(tp,c77777789.ffilter2,1,1,tc)
	g1:Merge(g2)
	g1:Merge(g3)
	end
	Duel.SetFusionMaterial(g1)
end

function c77777789.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777789.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function c77777789.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end

function c77777789.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE)or c:IsFaceup()) and (c:IsSetCard(0x407)or c:IsSetCard(0x3e7)or c:IsSetCard(0x144)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777789.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c77777789.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777789.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777789.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777789.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77777789.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77777789.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
