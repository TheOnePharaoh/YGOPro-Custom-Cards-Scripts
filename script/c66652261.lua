--No. 29 Shadowbane
function c66652261.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac403),8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x48)
	c:RegisterEffect(e2)
	--destroy&damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(54366836,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e3:SetCountLimit(1)
	e3:SetCondition(c66652261.descon)
	e3:SetCost(c66652261.descost)
	e3:SetTarget(c66652261.destg)
	e3:SetOperation(c66652261.desop)
	c:RegisterEffect(e3)
	--rescue
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66652261,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(c66652261.rescon)
	e4:SetCost(c66652261.rescost)
	e4:SetOperation(c66652261.resop)
	c:RegisterEffect(e4)
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c66652261.incon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c66652261.damcon)
	e6:SetOperation(c66652261.damop)
	c:RegisterEffect(e6)
	--attribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e7)
end
c66652261.xyz_number=29
function c66652261.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsFaceup() and d:IsFaceup() and a:IsCode(66652261) and not d:IsRace(RACE_MACHINE) 
		or a and d and a:IsFaceup() and d:IsFaceup() and not a:IsRace(RACE_MACHINE) and  d:IsCode(66652261)
end
function c66652261.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66652261.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetSum(Card.GetAttack))
end
function c66652261.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local atk=0
		local tc=dg:GetFirst()
		while tc do
			if tc:IsPreviousPosition(POS_FACEUP) then
				atk=atk+tc:GetPreviousAttackOnField()
			end
			tc=dg:GetNext()
		end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c66652261.rescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end
function c66652261.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsAbleToDeckAsCost()
end
function c66652261.rescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652261.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c66652261.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_REMOVED) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c66652261.resop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c66652261.operation)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	Duel.SetLP(tp,500,REASON_EFFECT)
end
function c66652261.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c66652261.incon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c66652261.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and c:GetSummonType()==SUMMON_TYPE_XYZ and c:IsRelateToBattle() and eg:GetFirst()==c:GetBattleTarget()
end
function c66652261.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-tp,ev,false)
end
