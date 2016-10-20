--T.M. Holy Lancer
function c55438796.initial_effect(c)
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
	e2:SetCondition(c55438796.spcon)
	e2:SetOperation(c55438796.spop)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c55438796.pertg)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55438796,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,55438796)
	e4:SetTarget(c55438796.destg)
	e4:SetOperation(c55438796.desop)
	c:RegisterEffect(e4)
	--special summon2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438796,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c55438796.condition)
	e5:SetTarget(c55438796.target)
	e5:SetOperation(c55438796.operation)
	c:RegisterEffect(e5)
end
function c55438796.pertg(e,c)
	return c:IsSetCard(0xd70)
end
function c55438796.spfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438796.spcon(e,c)
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
			return Duel.IsExistingMatchingCard(c55438796.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c55438796.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c55438796.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c55438796.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c)
	end
end
function c55438796.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(55438812) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c55438796.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
		else
			local sg=Duel.GetMatchingGroup(c55438796.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
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
		g=Duel.SelectMatchingCard(tp,c55438796.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438796.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c55438796.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c55438796.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c55438796.desfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c55438796.desfilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c55438796.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c55438796.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438796.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(5) and not c:IsCode(55438796) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438796.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438796.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438796.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438796.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end