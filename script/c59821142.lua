--The Idol's Blinding Radiance
function c59821142.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c59821142.eqfilter)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c59821142.eqlimit)
	c:RegisterEffect(e3)
	--rank
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c59821142.rktg)
	e4:SetOperation(c59821142.rkop)
	c:RegisterEffect(e4)
	--atk&prop
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(59821142,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1)
	e5:SetCondition(c59821142.atkcon)
	e5:SetTarget(c59821142.atktg)
	e5:SetOperation(c59821142.atkop)
	c:RegisterEffect(e5)
end
function c59821142.eqlimit(e,c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ)
end
function c59821142.eqfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ)
end
function c59821142.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c59821142.rktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821142.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local rk=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
	Duel.SetTargetParam(rk)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,PLAYER_ALL,2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,rk*300)
end
function c59821142.rkop(e,tp,eg,ep,ev,re,r,rp)
	local rk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local coin1=Duel.TossCoin(tp,1)
	local coin2=Duel.TossCoin(1-tp,1)
	if coin1==1 and coin2==1 then
		local g=Duel.GetMatchingGroup(c59821142.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(rk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	elseif coin1==0 and coin2==0 then
		Duel.Damage(tp,rk*300,REASON_EFFECT)
	end
end
function c59821142.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	return tc and tc:IsFaceup() and bit.band(tc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c59821142.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	e:SetLabel(rc)
end
function c59821142.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local val=g:GetSum(Card.GetRank)*200
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(rc)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(val)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(val)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e3)
end