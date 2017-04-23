--S.A.P.A Daikatana
function c20912302.initial_effect(c)
	c:SetSPSummonOnce(20912302)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c20912302.sumcon)
	e0:SetTarget(c20912302.sumtg)
	e0:SetOperation(c20912302.sumop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912302,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c20912302.eqtg)
	e1:SetOperation(c20912302.eqop)
	c:RegisterEffect(e1)
	--Convert race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20912302.equipcon)
	e2:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912302,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c20912302.descon)
	e3:SetTarget(c20912302.destg)
	e3:SetOperation(c20912302.desop)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd0a3))
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0xd0a2)
	c:RegisterEffect(e4)
	--unequip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20912302,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(aux.IsUnionState)
	e5:SetTarget(c20912302.sptg)
	e5:SetOperation(c20912302.spop)
	c:RegisterEffect(e5)
	--piercing
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e6)
	--Atk up
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(500)
	e7:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e7)
	--destroy sub
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e8:SetCondition(aux.IsUnionState)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--Equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(c20912302.eqlimit)
	c:RegisterEffect(e9)
end
c20912302.old_union=true
function c20912302.condfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c20912302.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20912302.condfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20912302.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20912302.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c20912302.propfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912302.equipcon(e)
	return Duel.IsExistingMatchingCard(c20912302.propfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c20912302.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:GetUnionCount()==0
end
function c20912302.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912302.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetFlagEffect(20912302)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20912302.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c20912302.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(20912302,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c20912302.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c20912302.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c20912302.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c20912302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(20912302)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(20912302,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c20912302.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c20912302.confilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP) and c:GetPreviousControler()==tp
end
function c20912302.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c20912302.confilter,1,nil,tp)
end
function c20912302.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c20912302.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end