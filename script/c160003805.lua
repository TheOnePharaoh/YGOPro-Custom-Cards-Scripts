--Number 98:Jerked Brunette
function c160003805.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12744567,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c160003805.matcon)
	e1:SetCost(c160003805.cost)
	e1:SetTarget(c160003805.mattg)
	e1:SetOperation(c160003805.matop)
	e1:SetLabel(2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160003805,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c160003805.negcon)
	e2:SetCost(c160003805.cost)
	e2:SetTarget(c160003805.negtg)
	e2:SetOperation(c160003805.negop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--no traps
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c160003805.efilter)
	--atkdown
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21521304,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c160003805.cost)
	e5:SetTarget(c160003805.adtg)
	e5:SetOperation(c160003805.adop)
	e5:SetLabel(1)
	c:RegisterEffect(e5)
	--Special SUmmon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(102380,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c160003805.cost)
	e6:SetTarget(c160003805.sptg)
	e6:SetOperation(c160003805.spop)
	e6:SetLabel(1)
	c:RegisterEffect(e6)
end
function c160003805.matcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c160003805.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c160003805.matfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160003805.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c160003805.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160003805.matfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c160003805.matfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c160003805.matop(e,tp,eg,ep,ev,re,r,rp)
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
function c160003805.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_NEGATE)
	if ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 then return true end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c160003805.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160003805.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c160003805.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c160003805.adfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c160003805.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c160003805.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
		and c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c160003805.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c160003805.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c160003805.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c160003805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160003805.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c160003805.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160003805.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
