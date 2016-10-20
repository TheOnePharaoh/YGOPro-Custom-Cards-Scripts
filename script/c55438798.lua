--T.M. Drago
function c55438798.initial_effect(c)
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
	e2:SetCondition(c55438798.spcon)
	e2:SetOperation(c55438798.spop)
	c:RegisterEffect(e2)
	--special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55438798,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c55438798.condition)
	e3:SetTarget(c55438798.target)
	e3:SetOperation(c55438798.operation)
	c:RegisterEffect(e3)
	--damage2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(46263076,1))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetTarget(c55438798.damtg2)
	e7:SetOperation(c55438798.damop2)
	c:RegisterEffect(e7)
	--damage1
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438798,2))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,55438798)
	e5:SetTarget(c55438798.damtg1)
	e5:SetOperation(c55438798.damop1)
	c:RegisterEffect(e5)
end
function c55438798.spfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c55438798.spcon(e,c)
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
			return Duel.IsExistingMatchingCard(c55438798.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,c)
		else
			local ct=-ft+1
			return Duel.IsExistingMatchingCard(c55438798.spfilter,tp,LOCATION_MZONE,0,ct,nil)
				and Duel.IsExistingMatchingCard(c55438798.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,c)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c55438798.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,c)
	end
end
function c55438798.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(55438812) then
		if ft>0 then
			g=Duel.SelectMatchingCard(tp,c55438798.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
		else
			local sg=Duel.GetMatchingGroup(c55438798.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c)
			local ct=-ft+1
			g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
			if ct<2 then
				sg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=sg:Select(tp,2-ct,2-ct,nil)
				g:Merge(g2)
			end
		end
	else
		g=Duel.SelectMatchingCard(tp,c55438798.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55438798.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438798.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(7) and not c:IsCode(55438798) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438798.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438798.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438798.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438798.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438798.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	local ct2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	local ct=ct2-ct1
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c55438798.damop1(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	local ct2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_MONSTER)
	local ct=ct2-ct1
	if ct>0 then
		local val=Duel.Recover(tp,ct*500,REASON_EFFECT)
		Duel.Damage(1-tp,val,REASON_EFFECT)
	end
end
function c55438798.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c55438798.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end