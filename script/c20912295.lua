--Lady of the Former Magi
function c20912295.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(c20912295.eqtg)
	e1:SetOperation(c20912295.eqop)
	c:RegisterEffect(e1)
	--spsummon1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912295,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,20912295)
	e2:SetTarget(c20912295.sptg1)
	e2:SetOperation(c20912295.spop1)
	c:RegisterEffect(e2)
	--spsummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912295,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,20912295)
	e3:SetTarget(c20912295.sptg2)
	e3:SetOperation(c20912295.spop2)
	c:RegisterEffect(e3)
	--Convert race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c20912295.eqcon)
	e4:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e4)
end
function c20912295.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2)
end
function c20912295.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912295.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20912295.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20912295.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20912295.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(tc)
	e1:SetValue(c20912295.eqlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c20912295.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c20912295.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and not c:IsType(TYPE_XYZ)
end
function c20912295.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912295.spfilter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c20912295.spfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20912295,2))
	Duel.SelectTarget(tp,c20912295.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20912295.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetLevel()<2 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20912295.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c20912295.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and not c:IsType(TYPE_XYZ)
end
function c20912295.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912295.spfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c20912295.spfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20912295,2))
	Duel.SelectTarget(tp,c20912295.spfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20912295.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetLevel()<2 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-1)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20912295.propfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER) and not c:IsCode(20912295)
end
function c20912295.eqcon(e)
	return Duel.IsExistingMatchingCard(c20912295.propfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end