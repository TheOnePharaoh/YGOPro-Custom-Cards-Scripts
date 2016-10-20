--T.M. Master El Vain
function c55438801.initial_effect(c)
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
	e2:SetCondition(c55438801.spcon)
	e2:SetOperation(c55438801.spop)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(55438799)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c55438801.destg)
	e4:SetOperation(c55438801.desop)
	c:RegisterEffect(e4)
	--special summon2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438801,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c55438801.condition)
	e5:SetTarget(c55438801.target)
	e5:SetOperation(c55438801.operation)
	c:RegisterEffect(e5)
	--atk down
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438801,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,55438801)
	e6:SetTarget(c55438801.atkctg)
	e6:SetOperation(c55438801.atkcop)
	c:RegisterEffect(e6)
end
function c55438801.spfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438801.spcon(e,c)
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
			return Duel.IsExistingMatchingCard(c55438801.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c55438801.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c55438801.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c55438801.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,c)
	end
end
function c55438801.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(55438812) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c55438801.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,3,3,c)
		else
			local sg=Duel.GetMatchingGroup(c55438801.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
			local ct=-ft+1
			g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
			if ct<3 then
				sg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=sg:Select(tp,3-ct,3-ct,nil)
				g:Merge(g2)
			end
		end
	else
		g=Duel.SelectMatchingCard(tp,c55438801.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,3,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438801.desfilter(c)
	return (c:IsFacedown() or not c:IsSetCard(0xd70)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c55438801.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438801.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c55438801.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c55438801.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55438801.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c55438801.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438801.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(10) and not c:IsCode(55438801) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438801.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438801.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438801.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438801.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438801.atkctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c55438801.atkcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local d=Duel.TossDice(tp,1)*100
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(-d)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end