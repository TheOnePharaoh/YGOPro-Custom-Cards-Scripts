--Executioner Smough
--Lua script by SGJin
function c12310756.initial_effect(c)
	--Hammer time
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12310756.discon)
	e1:SetOperation(c12310756.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c12310756.atkcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310756,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,12310756)
	e3:SetCost(c12310756.eqcost)
	e3:SetTarget(c12310756.eqtg)
	e3:SetOperation(c12310756.eqop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c12310756.discon1)
	e4:SetOperation(c12310756.disop1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_CALCULATING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c12310756.atkup)
	c:RegisterEffect(e5)
end
function c12310756.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==a and d and d:IsDefensePos()
end
function c12310756.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function c12310756.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310756.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12310756.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12310756.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(6)
end
function c12310756.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12310756.filter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c12310756.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12310756.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12310756.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c12310756.eqlimit)
	c:RegisterEffect(e1)
end
function c12310756.atkup(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and a==eqc and d:IsDefensePos() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1000)
		a:RegisterEffect(e1)
	end
end
function c12310756.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c12310756.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and c:GetBattleTarget()
end
function c12310756.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetCondition(c12310756.discon2)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e2:SetOperation(c12310756.disop2)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
end
function c12310756.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c12310756.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	c:CreateRelation(tc,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetCondition(c12310756.discon2)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e2:SetOperation(c12310756.disop2)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
end
function c12310756.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c12310756.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and re:GetHandler()==e:GetLabelObject() then
		Duel.NegateEffect(ev)
	end
end
