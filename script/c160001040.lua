--Number C98: Brunette, The Smooth Killer
function c160001040.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),7,3)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160001040,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,160001040)
	e1:SetCondition(c160001040.con)
	e1:SetTarget(c160001040.mttg)
	e1:SetOperation(c160001040.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160001040,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,160001043)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c160001040.negcon)
	e2:SetCost(c160001040.negcost)
	e2:SetTarget(c160001040.negtg)
	e2:SetOperation(c160001040.negop)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21521304,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,160001042)
	e3:SetCondition(c160001040.con)
	e3:SetCost(c160001040.adcost)
	e3:SetTarget(c160001040.adtg)
	e3:SetOperation(c160001040.adop)
	c:RegisterEffect(e3)
	--Special SUmmon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(102380,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,160001041)
	e4:SetCondition(c160001040.con)
	e4:SetCost(c160001040.spcost)
	e4:SetTarget(c160001040.sptg)
	e4:SetOperation(c160001040.spop)
	c:RegisterEffect(e4)			
	--Copy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11522979,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,160001044)
	e5:SetCondition(c160001040.con)
	e5:SetCost(c160001040.copycost)
	e5:SetTarget(c160001040.copytg)
	e5:SetOperation(c160001040.copyop)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c160001040.splimit)
	c:RegisterEffect(e6)
	--attack all
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ATTACK_ALL)
	e7:SetValue(c160001040.atkfilter)
	c:RegisterEffect(e7)
	--immune trap
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c160001040.efilter)
	c:RegisterEffect(e8)
	--leave
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetCountLimit(1,160001039)
	e9:SetCondition(c160001040.atkcon)
	e9:SetOperation(c160001040.atkop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e11)
	--self destroy
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SELF_TOGRAVE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e12:SetTargetRange(LOCATION_ONFIELD,0)
	e12:SetTarget(c160001040.destg)
	c:RegisterEffect(e12)
end
function c160001040.destg(e,c)
	return not c:IsSetCard(0x89b) and not c:IsSetCard(0x45)
end
function c160001040.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,160003805)
end
function c160001040.mtfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160001040.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c160001040.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160001040.mtfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c160001040.mtfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c160001040.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end     
function c160001040.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,160003805)
end
function c160001040.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c160001040.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160001040.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end	
function c160001040.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5,true)
end
function c160001040.adfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c160001040.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160001040.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c160001040.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c160001040.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-2000)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end

end
function c160001040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c160001040.spfilter(c,e,tp)
	return c:IsLevelAbove(7) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c160001040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160001040.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c160001040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160001040.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c160001040.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(160002144)
end
function c160001040.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c160001040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c160001040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c160001040.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c160001040.copyfilter(c,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	return c:GetType()==TYPE_SPELL and (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
		and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
end
function c160001040.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c160001040.copyfilter(chkc,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c160001040.copyfilter,tp,0,LOCATION_GRAVE,1,nil,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160001040,4))
	local tc=Duel.SelectTarget(tp,c160001040.copyfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp,eg,ep,ev,re,r,rp):GetFirst()
	local te=tc:GetActivateEffect()
	e:SetLabelObject(te)
	local co=te:GetCost()
	local tg=te:GetTarget()
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c160001040.copyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c160001040.atkfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

function c160001040.splimit2(e,c)
	return not c:IsSetCard(0x89b) or not c:IsSetCard(0x45)
end
function c160001040.excon(e)
	return Duel.IsExistingMatchingCard(c160001040.exfilter,0,LOCATION_ONFIELD,0,1,nil)
end
function c160001040.destg(e,c)
	return not c:IsFaceup() or (not c:IsSetCard(0x45) and not c:IsSetCard(0x89b))
end
