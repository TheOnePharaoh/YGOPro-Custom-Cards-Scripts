--T.M. Gardna
function c55438795.initial_effect(c)
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
	e2:SetCondition(c55438795.spcon)
	e2:SetOperation(c55438795.spop)
	c:RegisterEffect(e2)
	--untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c55438795.atlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(0,0xff)
	e4:SetValue(c55438795.tglimit)
	c:RegisterEffect(e4)
	--flip down
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55438795,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,55438795)
	e4:SetTarget(c55438795.settg)
	e4:SetOperation(c55438795.setop)
	c:RegisterEffect(e4)
	--special summon2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438795,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c55438795.condition)
	e5:SetTarget(c55438795.target)
	e5:SetOperation(c55438795.operation)
	c:RegisterEffect(e5)
end
function c55438795.spfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438795.spcon(e,c)
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
			return Duel.IsExistingMatchingCard(c55438795.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c55438795.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c55438795.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c55438795.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c)
	end
end
function c55438795.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(55438812) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c55438795.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
		else
			local sg=Duel.GetMatchingGroup(c55438795.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
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
		g=Duel.SelectMatchingCard(tp,c55438795.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438795.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xd70) and c~=e:GetHandler()
end
function c55438795.tglimit(e,re,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xd70) and c~=e:GetHandler()
end
function c55438795.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c55438795.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c55438795.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c55438795.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c55438795.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c55438795.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c55438795.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438795.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(4) and not c:IsCode(55438795) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438795.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438795.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438795.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438795.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end