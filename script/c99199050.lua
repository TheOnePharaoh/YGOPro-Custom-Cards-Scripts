--The Future Gear Master Sword
function c99199050.initial_effect(c)
	c:SetSPSummonOnce(99199050)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c99199050.spcost)
	e1:SetTarget(c99199050.sptg)
	e1:SetOperation(c99199050.spop)
	c:RegisterEffect(e1)
	--atk/lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199050,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c99199050.operation)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0xff16)
	c:RegisterEffect(e3)
end
function c99199050.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199050.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c99199050.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c99199050.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c99199050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99199050.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99199050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-2)
		c:RegisterEffect(e1)
	end
end