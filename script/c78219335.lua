--No. 27: Colossal Warrior N.A.N.O Rider
function c78219335.initial_effect(c)
	c:SetCounterLimit(0x1115,5)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,2)
	c:EnableReviveLimit()
	--Battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78219335,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c78219335.atkcon)
	e1:SetCost(c78219335.atkcost)
	e1:SetOperation(c78219335.atkop)
	c:RegisterEffect(e1)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0x48)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78219335,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c78219335.xyzcost)
	e5:SetTarget(c78219335.xyztg)
	e5:SetOperation(c78219335.xyzop)
	c:RegisterEffect(e5)
	--send replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetCondition(c78219335.repcon)
	e6:SetOperation(c78219335.repop)
	c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetOperation(c78219335.counter)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(78219335,2))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c78219335.spcost)
	e8:SetTarget(c78219335.sptg)
	e8:SetOperation(c78219335.spop)
	c:RegisterEffect(e8)
end
c78219335.xyz_number=27
function c78219335.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler()
end
function c78219335.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:GetFlagEffect(78219335)==0 end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
	c:RegisterFlagEffect(78219335,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c78219335.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(d:GetAttack())
	a:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	d:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	d:RegisterEffect(e3)
end
function c78219335.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1115,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1115,3,REASON_COST)
end
function c78219335.xyzfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToChangeControler()
		and not c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c78219335.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c78219335.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78219335.xyzfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c78219335.xyzfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c78219335.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c78219335.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219335.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219335,e,0,tp,0,0)
end
function c78219335.cfilter(c)
	return c:IsSetCard(0x7ad30) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function c78219335.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c78219335.cfilter,1,nil) then
		e:GetHandler():AddCounter(0x1115,1)
	end
end
function c78219335.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1115,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1115,2,REASON_COST)
end
function c78219335.specifilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c78219335.chkfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetControler(),c:GetCode())
end
function c78219335.chkfilter(c,e,tp,cc,code)
	return c:IsSetCard(0x7ad30) and not c:IsCode(code) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),cc,0x21,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function c78219335.spfilter(c,e,tp,cc,code)
	return c:IsSetCard(0x7ad30) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,cc)
end
function c78219335.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c78219335.specifilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c78219335.specifilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c78219335.specifilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c78219335.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local cc=tc:GetControler()
	local code=tc:GetCode()
	local g=Duel.GetMatchingGroup(c78219335.chkfilter,tp,LOCATION_DECK,0,nil,e,tp,cc,code)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and g:GetCount()>0 then
		Duel.BreakEffect()
		g=Duel.GetMatchingGroup(c78219335.spfilter,tp,LOCATION_DECK,0,nil,e,tp,cc,code)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,cc,false,false,POS_FACEUP)
		end
	end
end