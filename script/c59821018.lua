--The Idol Smackdown
function c59821018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59821018.condition)
	e1:SetTarget(c59821018.target)
	e1:SetOperation(c59821018.activate)
	c:RegisterEffect(e1)
end
function c59821018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c59821018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049) and c:GetFlagEffect(59821018)==0
end
function c59821018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c59821018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821018.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c59821018.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c59821018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(59821018)==0 then
			tc:RegisterFlagEffect(59821018,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetCondition(c59821018.actcon)
			e1:SetValue(c59821018.aclimit)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c59821018.effcon)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e3:SetCondition(c59821018.damcon)
			e3:SetOperation(c59821018.damop)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetCondition(c59821018.effcon)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end
function c59821018.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c59821018.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c59821018.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c59821018.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetOwnerPlayer()==tp
end
function c59821018.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
