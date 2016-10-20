--Yami Mail Card
function c500312301.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c500312301.reg)
	c:RegisterEffect(e1)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500312301,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c500312301.sccon)
	e2:SetOperation(c500312301.scop)
	c:RegisterEffect(e2)
	--unnegatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c500312301.unnegop)
	c:RegisterEffect(e3)
	--to defense
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500312301,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c500312301.postg)
	e4:SetOperation(c500312301.posop)
	c:RegisterEffect(e4)
	--boost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTarget(c500312301.decrease)
	e5:SetValue(-200)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--splimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c500312301.splimit)
	e7:SetCondition(c500312301.splimcon)
	c:RegisterEffect(e7)
end
function c500312301.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(500312301,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end
function c500312301.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc81)
end
function c500312301.unnegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()~=tp or c:GetFlagEffect(500312301)>0 then return end
	Duel.Hint(HINT_CARD,0,500312301)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c500312301.filter,tp,LOCATION_MZONE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		g:KeepAlive()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetRange(LOCATION_PZONE)
		e2:SetValue(c500312301.effectfilter)
		e2:SetLabelObject(g)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetRange(LOCATION_PZONE)
		e3:SetLabelObject(g)
		e3:SetValue(c500312301.effectfilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function c500312301.effectfilter(e,ct)
	local g=e:GetLabelObject()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return g:IsContains(tc)
end
function c500312301.sccon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0xc81)
end
function c500312301.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(11)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c500312301.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c500312301.splimit(e,c)
	return not c:IsSetCard(0xc81)
end
function c500312301.decrease(e,c)
	return not c:IsSetCard(0xc81)
end
function c500312301.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c500312301.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c500312301.tg(e,c)
	return c:IsSetCard(0xc81)
end
function c500312301.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xc81) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500312301.splimcon(e)
	return not e:GetHandler():IsForbidden()
end