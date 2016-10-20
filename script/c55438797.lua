--T.M. Great Angel
function c55438797.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c55438797.spcon)
	e2:SetOperation(c55438797.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55438797,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCost(c55438797.atkcost)
	e3:SetOperation(c55438797.atkop)
	c:RegisterEffect(e3)
	--special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55438797,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c55438797.condition)
	e4:SetTarget(c55438797.target)
	e4:SetOperation(c55438797.operation)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438797,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,55438797)
	e5:SetTarget(c55438797.thtg)
	e5:SetOperation(c55438797.thop)
	c:RegisterEffect(e5)
end
function c55438797.spfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438797.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_LIGHT) then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	if sum>12 then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	if c:IsHasEffect(55438812) then
		if ft>0 then
			return Duel.IsExistingMatchingCard(c55438797.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c55438797.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c55438797.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c55438797.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c)
	end
end
function c55438797.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(55438812) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c55438797.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
		else
			local sg=Duel.GetMatchingGroup(c55438797.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
			local ct=-ft+1
			g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
			if ct<1 then
				sg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=sg:Select(tp,1-ct,1-ct,nil)
				g:Merge(g2)
			end
		end
	else
		g=Duel.SelectMatchingCard(tp,c55438797.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438797.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsAbleToRemoveAsCost()
end
function c55438797.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438797.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55438797.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438797.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c55438797.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438797.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(6) and not c:IsCode(55438797) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438797.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438797.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438797.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438797.thfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c55438797.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438797.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55438797.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55438797.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end