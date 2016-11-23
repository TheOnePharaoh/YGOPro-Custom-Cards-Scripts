--Curse of the Martyr
function c87002918.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetLabel(1)
	e1:SetCondition(c87002918.condition)
	e1:SetCost(c87002918.cost)
	e1:SetTarget(c87002918.target)
	e1:SetOperation(c87002918.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,87002918)
	e4:SetCost(c87002918.setcost)
	e4:SetTarget(c87002918.settg)
	e4:SetOperation(c87002918.setop)
	c:RegisterEffect(e4)
end
function c87002918.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c87002918.cfilter(c,def)
	return c:IsFaceup() and c:IsSetCard(0xe291ca) and c:IsAttackAbove(def) and not c:IsCode(87002902)
end
function c87002918.filter(c,atk)
	return c:IsFaceup() and (not atk or c:IsDefenseBelow(atk))
end
function c87002918.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c87002918.filter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return false end
		local mg,mdef=g:GetMinGroup(Card.GetDefense)
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c87002918.cfilter,1,nil,mdef)
	end
	local g=Duel.GetMatchingGroup(c87002918.filter,tp,0,LOCATION_MZONE,nil)
	local mg,mdef=g:GetMinGroup(Card.GetDefense)
	local rg=Duel.SelectReleaseGroup(tp,c87002918.cfilter,1,1,nil,mdef)
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Release(rg,REASON_COST)
end
function c87002918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==0 end
	local dg=Duel.GetMatchingGroup(c87002918.filter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c87002918.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c87002918.filter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
end
function c87002918.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c87002918.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c87002918.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
