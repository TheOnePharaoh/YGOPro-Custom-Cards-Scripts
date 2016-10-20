--The Future Gear Rufus the Unbeatable
function c99199024.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99199024.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99199024.spcon)
	e2:SetOperation(c99199024.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199024,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c99199024.destg)
	e3:SetOperation(c99199024.desop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199024,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c99199024.condition)
	e4:SetTarget(c99199024.target)
	e4:SetOperation(c99199024.operation)
	c:RegisterEffect(e4)
end
function c99199024.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c99199024.spfilter1(c,tp,fc)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c99199024.spfilter2,1,c,fc)
end
function c99199024.spfilter2(c,fc)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial(fc)
end
function c99199024.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c99199024.spfilter1,1,nil,tp,c)
end
function c99199024.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c99199024.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c99199024.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c99199024.tgfilter(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15)
	else
		return c:IsSetCard(0xff15) and c:GetSequence()==6 or c:GetSequence()==7
	end
end
function c99199024.desfilter(c)
	return c99199024.tgfilter(c) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c99199024.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c99199024.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99199024.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99199024.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end
function c99199024.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c99199024.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c99199024.specfilter(c,e,tp)
	return c:IsSetCard(0xff15) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99199024.specfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99199024.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99199024.specfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end