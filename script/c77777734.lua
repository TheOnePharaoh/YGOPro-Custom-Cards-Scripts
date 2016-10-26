--Necromantic Reaper
function c77777734.initial_effect(c)
	--ritual level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c77777734.rlevel)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77777734.condition)
	e2:SetOperation(c77777734.operation)
	c:RegisterEffect(e2)
end

function c77777734.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x1c8) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c77777734.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c77777734.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if rc:IsSetCard(0x1c8)then
	while rc do
		if rc:GetFlagEffect(77777734)==0 then
			--gains atk
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(77777734,1))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(77777734,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(500)
			rc:RegisterEffect(e2,true)
			--damage
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetCategory(CATEGORY_DAMAGE)
			e3:SetDescription(aux.Stringid(77777734,2))
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetCode(EVENT_BATTLE_DAMAGE)
			e3:SetCondition(c77777734.damcon)
			e3:SetTarget(c77777734.damtg)
			e3:SetOperation(c77777734.damop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e3,true)
			rc:RegisterFlagEffect(77777734,RESET_EVENT+0x1fe0000,0,1)
		end
		rc=eg:GetNext()
	end
	end
end

function c77777734.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77777734.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77777734.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,500,REASON_EFFECT)
end
