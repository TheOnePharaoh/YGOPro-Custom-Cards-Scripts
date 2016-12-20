--Witchcrafter Tyra
function c77777709.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777709.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777709,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777709.sccon)
--	e3:SetTarget(c77777709.sctg)
	e3:SetOperation(c77777709.scop)
	c:RegisterEffect(e3)
	--PZ Unaffected by card effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCondition(c77777709.uncon)
	e4:SetTarget(c77777709.indtg)
	e4:SetValue(c77777709.efilter)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777709,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77777709.descon)
	e5:SetTarget(c77777709.destg)
	e5:SetOperation(c77777709.desop)
	c:RegisterEffect(e5)
	--Atk up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77777709.atkval)
	c:RegisterEffect(e6)
	
end

function c77777709.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777709.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77777709.atkval(e,c)
	return Duel.GetMatchingGroupCount(c77777709.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*50
end
function c77777709.atkfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsFaceup()
end

function c77777709.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end


function c77777709.desfilter(c)
	return c:IsDestructable()
end
function c77777709.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c77777709.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingMatchingCard(c77777709.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c77777709.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c77777709.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.Destroy(tc,REASON_EFFECT)
end

function c77777709.uncon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return (c:GetLeftScale()==c:GetOriginalLeftScale()) and (c:GetRightScale()==c:GetOriginalRightScale())
end
function c77777709.indtg(e,c)
	return c:IsSetCard(0x407) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c77777709.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
